Codeunit 7207349 "QB - Page - Subscriber"
{


    Permissions = TableData 454 = rimd;
    trigger OnRun()
    BEGIN
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 43"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 43, OnAfterActionEvent, QB_SuggestDueMilestone, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_SuggestDueMilestone_PSalesInvoice(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            GenerateMilestones(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 43, OnAfterActionEvent, QB_GenerateMilestoneBudget, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_GenerateMilestoneBudget_PSalesInvoice(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            GenerateMilestonesBudget(Rec);
    END;

    LOCAL PROCEDURE GenerateMilestones(VAR OldSalesHeader: Record 36; BooControlHeader: Boolean);
    VAR
        // repGenMilestone: Report 7207287;
        InvoiceMilestone: Record 7207331;
    BEGIN
        // CLEAR(repGenMilestone);
        // repGenMilestone.SetSalesHeader(OldSalesHeader, BooControlHeader);
        InvoiceMilestone.RESET;
        InvoiceMilestone.SETRANGE(InvoiceMilestone."Customer Code", OldSalesHeader."Sell-to Customer No.");
        IF OldSalesHeader."Currency Code" <> '' THEN InvoiceMilestone.SETRANGE(InvoiceMilestone."Currency Code", OldSalesHeader."Currency Code");
        IF OldSalesHeader."QB Job No." <> '' THEN
            InvoiceMilestone.SETRANGE(InvoiceMilestone."Job No.", OldSalesHeader."QB Job No.");
        // repGenMilestone.SETTABLEVIEW(InvoiceMilestone);
        // repGenMilestone.RUNMODAL;
    END;

    LOCAL PROCEDURE GenerateMilestonesBudget(VAR OldSalesHeader: Record 36);
    VAR
        // repGenMilestBudget: Report 7207288;
        locJobPlanningLine: Record 1003;
        Text033: TextConst ENU = 'If you want generate Invoices by budget lines by item you must specify a Job', ESP = 'Para poder generar facturas por l�neas de presupuesto por item es preciso indicar un proyecto';
    BEGIN

        // CLEAR(repGenMilestBudget);
        // repGenMilestBudget.SetCabVtas(OldSalesHeader);
        IF OldSalesHeader."QB Job No." = '' THEN
            ERROR(Text033);
        locJobPlanningLine.SETRANGE(locJobPlanningLine."Job No.", OldSalesHeader."QB Job No.");
        // repGenMilestBudget.SETTABLEVIEW(locJobPlanningLine);
        // repGenMilestBudget.RUNMODAL;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 50,509"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 50, OnBeforeActionEvent, QB_FichaContrato, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_ContractCard(VAR Rec: Record 38);
    VAR
        DocumentDataContracts: Record 7207391;
    BEGIN
        FillContractData(Rec);
        DocumentDataContracts.SETCURRENTKEY(DocumentDataContracts."Contract No.");
        DocumentDataContracts.SETRANGE("Contract No.", Rec."No.");
        PAGE.RUN(PAGE::"Purchase Contract Card", DocumentDataContracts);
    END;

    PROCEDURE FillContractData(PurchaseHeader: Record 38);
    VAR
        DocumentDataContracts: Record 7207391;
        DocumentDataJob: Record 7207391;
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        Initialize: Boolean;
    BEGIN
        //JAV 30/10/21: - QB 1.09.26 Se cambia la forma de rellenar los datos para que tome los del proyecto

        //Rellena los datos del contrato si no existe el registro cuando se deban usar para presentar la pantalla o para imprimir......
        IF NOT FunctionQB.AccessToQuobuilding THEN
            EXIT;

        //Si no existe el registro o ha cambiado el proveedor inicializo el registro
        Initialize := FALSE;
        IF (NOT DocumentDataContracts.GET(PurchaseHeader."QB Job No.", PurchaseHeader."No.")) THEN
            Initialize := TRUE
        ELSE IF (PurchaseHeader."Buy-from Vendor No." <> DocumentDataContracts."Vendor No.") THEN BEGIN
            DocumentDataContracts.DELETE;
            Initialize := TRUE;
        END;

        IF (Initialize) THEN BEGIN
            IF (DocumentDataJob.GET(PurchaseHeader."QB Job No.", '')) THEN    //Si hay registro general del proyecto lo utilizado de base
                DocumentDataContracts.TRANSFERFIELDS(DocumentDataJob)
            ELSE
                DocumentDataContracts.INIT;

            DocumentDataContracts."Job No." := PurchaseHeader."QB Job No.";
            DocumentDataContracts."Contract No." := PurchaseHeader."No.";
            DocumentDataContracts."Vendor No." := PurchaseHeader."Buy-from Vendor No."; //Q12932
            DocumentDataContracts.INSERT;
        END;

        //Actualizamos los datos del documento siempre por si han cambiado
        IF (NOT Job.GET(PurchaseHeader."QB Job No.")) THEN
            Job.INIT;
        DocumentDataContracts."Job Name" := Job.Description + ' ' + Job."Description 2";
        PurchaseHeader.CALCFIELDS(Amount);
        DocumentDataContracts."Work Import Contract" := PurchaseHeader.Amount;
        DocumentDataContracts.MODIFY;
    END;

    [EventSubscriber(ObjectType::Page, 50, OnBeforeActionEvent, QB_ProposeSubcontracting, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_ProposeSubcontracting_PPurchaseOrder(VAR Rec: Record 38);
    VAR
        PurchaseLine: Record 39;
    BEGIN
        //Acci�n "Proponer subcontrataci�n" que se lanza desde la page 50

        COMMIT; //JAV 22/03/21: - QB 1.08.27 Para evitar el error al hacer el run

        PurchaseLine.FILTERGROUP(2);
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        PurchaseLine.FILTERGROUP(0);
        IF NOT PurchaseLine.FINDLAST THEN BEGIN
            PurchaseLine."Document Type" := Rec."Document Type";
            PurchaseLine."Document No." := Rec."No.";
        END;
        CODEUNIT.RUN(CODEUNIT::GetSubcontract, PurchaseLine);
    END;

    [EventSubscriber(ObjectType::Page, 50, OnBeforeActionEvent, QB_ProposeValuedRelationship, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_ProposeaValuedRelationship_PPurchaseOrder(VAR Rec: Record 38);
    VAR
        HistProdMeasureLines: Record 7207402;
        PurchaseLine: Record 39;
        DataPieceworkForProduction: Record 7207386;
        DataCostByPiecework: Record 7207387;
        ProposeProductMeasurement: Page 7207590;
        Qty: Decimal;
    BEGIN
        //JAV 26/03/19: - La propuesta de pasar la medici�n al contrato se hace no solo para subcontratas
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF PurchaseLine.FINDSET(TRUE) THEN
            REPEAT
                PurchaseLine."Measured Qty." := 0;
                PurchaseLine."Measured Last Date" := 0D;
                IF DataPieceworkForProduction.GET(PurchaseLine."Job No.", PurchaseLine."Piecework No.") THEN BEGIN
                    HistProdMeasureLines.RESET;
                    HistProdMeasureLines.SETRANGE("Job No.", Rec."QB Job No.");
                    HistProdMeasureLines.SETRANGE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                    IF HistProdMeasureLines.FINDSET(FALSE) THEN
                        REPEAT
                            PurchaseLine."Measured Qty." += HistProdMeasureLines."Measure Term";
                            PurchaseLine."Measured Last Date" := HistProdMeasureLines."Posting Date";
                        UNTIL HistProdMeasureLines.NEXT = 0;
                    DataCostByPiecework.SETRANGE("Job No.", PurchaseLine."Job No.");
                    DataCostByPiecework.SETRANGE("Piecework Code", PurchaseLine."Piecework No.");
                    DataCostByPiecework.SETRANGE("No.", PurchaseLine."No.");
                    IF DataCostByPiecework.FINDFIRST THEN
                        PurchaseLine."Measured Proposed" := PurchaseLine."Measured Qty." * DataCostByPiecework."Performance By Piecework"
                    ELSE
                        PurchaseLine."Measured Proposed" := PurchaseLine."Measured Qty.";
                    PurchaseLine."Measured Proposed" -= PurchaseLine."Qty. Received (Base)";
                    //-Q20081
                    IF PurchaseLine."Measured Proposed" > PurchaseLine."Outstanding Qty. (Base)" THEN PurchaseLine."Measured Proposed" := PurchaseLine."Outstanding Qty. (Base)";
                    //+Q20081
                    PurchaseLine.MODIFY;
                END;
            UNTIL PurchaseLine.NEXT = 0;
        COMMIT;
        CLEAR(ProposeProductMeasurement);
        ProposeProductMeasurement.setPurchaseOrder(Rec);
        ProposeProductMeasurement.SETTABLEVIEW(PurchaseLine);
        ProposeProductMeasurement.LOOKUPMODE(TRUE);
        IF ProposeProductMeasurement.RUNMODAL = ACTION::LookupOK THEN BEGIN
            PurchaseLine.RESET;
            PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
            PurchaseLine.SETRANGE("Document No.", Rec."No.");
            IF PurchaseLine.FINDSET(TRUE) THEN
                REPEAT
                    PurchaseLine.VALIDATE("Qty. to Receive", PurchaseLine."Measured Proposed");
                    PurchaseLine.MODIFY;
                UNTIL PurchaseLine.NEXT = 0;
        END;
    END;

    [EventSubscriber(ObjectType::Page, 50, OnBeforeActionEvent, QB_Annexed, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_Annexed_PPurchaseOrder(VAR Rec: Record 38);
    VAR
        PurchaseLine: Record 39;
        // AnnexPurchaseLines: Report 7207381;
        Text001: TextConst ENU = 'The Order is not a contract', ESP = 'El Pedido no es un contrato';
    BEGIN
        IF Rec."QB Contract" THEN BEGIN
            PurchaseLine.SETRANGE(PurchaseLine."Document Type", Rec."Document Type");
            PurchaseLine.SETRANGE(PurchaseLine."Document No.", Rec."No.");
            // AnnexPurchaseLines.SETTABLEVIEW(PurchaseLine);
            // AnnexPurchaseLines.RUNMODAL;
            // CLEAR(AnnexPurchaseLines);
        END ELSE
            ERROR(Text001);
    END;

    [EventSubscriber(ObjectType::Page, 509, OnAfterActionEvent, QB_ContractCard, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_ContractCard_PBlanketPurchaseOrder(VAR Rec: Record 38);
    VAR
        DocumentDataContracts: Record 7207391;
    BEGIN
        FillContractData(Rec);
        DocumentDataContracts.SETCURRENTKEY(DocumentDataContracts."Contract No.");
        DocumentDataContracts.SETRANGE("Contract No.", Rec."No.");
        PAGE.RUN(PAGE::"Purchase Contract Card", DocumentDataContracts);
    END;

    [EventSubscriber(ObjectType::Page, 509, OnAfterActionEvent, QB_PrintContract, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_PrintContract_PBlanketPurchaseOrder(VAR Rec: Record 38);
    VAR
        DocPrint: Codeunit 229;
    BEGIN
        DocPrint.PrintPurchHeader(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 509, OnAfterActionEvent, QB_Attachment, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_ShowAttachment_PBlanketPurchaseOrder(VAR Rec: Record 38);
    VAR
        // AnnexPurchaseLines: Report 7207381;
        PurchaseLine: Record 39;
    BEGIN
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", Rec."Document Type");
        PurchaseLine.SETRANGE(PurchaseLine."Document No.", Rec."No.");
        // AnnexPurchaseLines.SETTABLEVIEW(PurchaseLine);
        // AnnexPurchaseLines.RUNMODAL;
        // CLEAR(AnnexPurchaseLines);
    END;

    [EventSubscriber(ObjectType::Page, 509, OnAfterActionEvent, QB_Test, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_PrintPurchaseHeader_PBlanketPurchaseOrder(VAR Rec: Record 38);
    VAR
        ReportPrint: Codeunit 228;
    BEGIN
        ReportPrint.PrintPurchHeader(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 50, OnBeforeActionEvent, QB_SendApprovalRequest, true, true)]
    LOCAL PROCEDURE P80_OnBeforeActionEvent_QBSendApprovalRequest(VAR Rec: Record 38);
    BEGIN
        //JAV 27/04/22: - QB 1.10.37 Verificar documento antes de solicitar aprobaci�n
        VerifyPurchaseDoc(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 50, OnBeforeActionEvent, Post, true, true)]
    LOCAL PROCEDURE P80_OnBeforeActionEvent_Post(VAR Rec: Record 38);
    BEGIN
        //JAV 27/04/22: - QB 1.10.37 Verificar documento antes de registrar
        VerifyPurchaseDoc(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 50, OnBeforeActionEvent, Preview, true, true)]
    LOCAL PROCEDURE P80_OnBeforeActionEvent_Preview(VAR Rec: Record 38);
    BEGIN
        //JAV 27/04/22: - QB 1.10.37 Verificar documento antes de la vista previa de registro
        VerifyPurchaseDoc(Rec);
    END;

    // [EventSubscriber(ObjectType::Codeunit, 7207352, OnRestrictionsReleasePurchDoc, '', true, true)]
    LOCAL PROCEDURE VerifyPurchaseDoc(PurchHeader: Record 38);
    VAR
        PurchLine: Record 39;
        GLAccount: Record 15;
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'If the order is against job, you can not specify location on line %1.', ESP = 'Si el pedido es contra proyecto no puede especificar almac�n en la l�nea %1.';
        Text001: TextConst ENU = 'If the order is against location, you can not specify location on line %1.', ESP = 'Si el pedido es contra almac�n no puede especificar proyecto en la l�nea %1.';
        Text002: TextConst ENU = 'In orders against job must specify job', ESP = 'En los pedidos contra proyecto debe especificar proyecto';
        Text002b: TextConst ENU = 'Can not be attributed to jobs of type imputation by breakdown', ESP = 'No se puede imputar a obras de tipo imputaci�n por desglose';
        Text003: TextConst ENU = 'In orders against location  must specify location', ESP = 'En los pedidos contra almac�n debe especificar almac�n';
        Text004: TextConst ENU = 'In orders against location only products can be indicated', ESP = 'En los pedidos contra almac�n solamente se pueden indicar productos';
    BEGIN
        //JAV 27/04/22: - QB 1.10.37 Verificar documento de compra
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            //JAV 27/05/22: - QB 1.10.45 Solo se verifica el proyecto si el pedido es contra proyecto
            IF (PurchHeader."QB Order To" = PurchHeader."QB Order To"::Job) AND (PurchHeader."QB Job No." = '') THEN
                ERROR('Debe indicar un proyecto en la cabecera');

            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            IF PurchLine.FINDSET(FALSE) THEN
                REPEAT
                    IF PurchHeader."QB Order To" = PurchHeader."QB Order To"::Job THEN BEGIN
                        IF PurchLine."Location Code" <> '' THEN
                            ERROR(Text000, PurchLine."Line No.");
                        IF (PurchLine.Type <> PurchLine.Type::"Fixed Asset") AND
                            (PurchLine.Type <> PurchLine.Type::" ") THEN BEGIN
                            IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN BEGIN
                                GLAccount.GET(PurchLine."No.");
                                IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                                    IF PurchLine."Job No." = '' THEN
                                        ERROR(Text002);
                                END;
                            END ELSE BEGIN
                                IF PurchLine."Job No." = '' THEN
                                    ERROR(Text002);
                            END;
                        END;
                    END;
                    IF PurchHeader."QB Order To" = PurchHeader."QB Order To"::Location THEN BEGIN
                        IF PurchLine."Job No." <> '' THEN
                            ERROR(Text001, PurchLine."Line No.");
                        //No se pueden comprar recursos contra almac�n
                        IF (PurchLine.Type = PurchLine.Type::Resource) OR
                           (PurchLine.Type = PurchLine.Type::"G/L Account") OR
                           (PurchLine.Type = PurchLine.Type::"Fixed Asset") THEN
                            ERROR(Text004, PurchLine."Line No.");
                        IF (PurchLine.Type <> PurchLine.Type::"Fixed Asset") AND
                           (PurchLine.Type <> PurchLine.Type::" ") THEN
                            IF PurchLine."Location Code" = '' THEN
                                ERROR(Text003, PurchLine."Line No.");
                    END;
                    //NO DEBE DEJAR IMPUTAR A PROYECTOS DE TIPO AGREGADO
                    IF PurchHeader."QB Order To" = PurchHeader."QB Order To"::Job THEN BEGIN
                        IF (PurchLine.Type <> PurchLine.Type::" ") AND
                            (PurchLine.Type <> PurchLine.Type::"Fixed Asset") THEN BEGIN
                            IF Job.GET(PurchLine."Job No.") THEN
                                IF Job."Allocation Item by Unfold" THEN
                                    ERROR(Text002b);
                        END;
                    END;
                UNTIL PurchLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 88"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 88, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_Pg88(VAR Rec: Record 167);
    BEGIN
        //JAV 29/02/20: - Nueva funci�n OnOpenPage88, al abrir la p�gina estandar de proyecto si este viene desde QuoBuilding abre la pantalla apropiada y cierra la estandar
        CASE Rec."Card Type" OF
            Rec."Card Type"::Estudio:
                BEGIN
                    IF (Rec."Original Quote Code" = '') THEN
                        PAGE.RUNMODAL(PAGE::"Quotes Card", Rec)
                    ELSE
                        PAGE.RUNMODAL(PAGE::"Versions Quote Card", Rec);
                    COMMIT;
                    ERROR('');
                END;
            Rec."Card Type"::"Proyecto operativo":
                BEGIN
                    PAGE.RUNMODAL(PAGE::"Operative Jobs Card", Rec);
                    COMMIT;
                    ERROR('');
                END;
            //JAV 22/02/22: - QB 1.10.21 Se a�aden los nuevos tipos de proyecto al abrir la p�gina est�ndar de Job Card
            Rec."Card Type"::Presupuesto:
                BEGIN
                    PAGE.RUNMODAL(PAGE::"QPR Budget Jobs Card", Rec);
                    COMMIT;
                    ERROR('');
                END;
            Rec."Card Type"::Promocion:
                BEGIN
                    PAGE.RUNMODAL(PAGE::"RE Active Card", Rec);
                    COMMIT;
                    ERROR('');
                END;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 92"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 92, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_Pg92(VAR Rec: Record 169);
    VAR
        Job: Record 167;
    BEGIN
        //JAV 06/02/20: - Solo se ver�n movimientos de un proyecto cuando se entra con filtro de proyecto
        IF (Rec.GETFILTER("Job No.") <> '') THEN BEGIN   //Si no hay fitro no hago esto para evitar que existe un proyecto en blanco y no entre
            IF Job.GET(Rec.GETFILTER("Job No.")) THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETRANGE("Job No.", Job."No.");
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- 104"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, DimensionFilterEnablePageAccountSchedule, '', true, true)]
    LOCAL PROCEDURE DimensionFilterEnablePageAccountSchedule(VAR filter1dimension: Boolean; VAR filter2dimension: Boolean; VAR filter3dimension: Boolean; VAR filter4dimension: Boolean);
    BEGIN
        filter1dimension := TRUE;
        filter2dimension := TRUE;
        filter3dimension := TRUE;
        filter4dimension := TRUE;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, ActualFiltersPageAccountSchedule, '', true, true)]
    LOCAL PROCEDURE ActualFiltersPageAccountSchedule(VAR AccScheduleLine: Record 85; VAR DimensionFilter1: Boolean; VAR DimensionFilter2: Boolean; VAR DimensionFilter3: Boolean; VAR DimensionFilter4: Boolean; currentSchedName: Code[10]);
    VAR
        RecAccSchedName: Record 84;
        RecAnalysisView: Record 363;
        RecGLSetup: Record 98;
    BEGIN
        RecAccSchedName.GET(currentSchedName);
        IF RecAccSchedName."Analysis View Name" <> '' THEN BEGIN
            IF NOT RecAnalysisView.GET(RecAccSchedName."Analysis View Name") THEN BEGIN
                RecGLSetup.GET;
                RecAnalysisView.INIT;
                RecAnalysisView."Dimension 1 Code" := RecGLSetup."Global Dimension 1 Code";
                RecAnalysisView."Dimension 2 Code" := RecGLSetup."Global Dimension 2 Code";
            END;
        END ELSE BEGIN
            RecGLSetup.GET;
            RecAnalysisView.INIT;
            RecAnalysisView."Dimension 1 Code" := RecGLSetup."Global Dimension 1 Code";
            RecAnalysisView."Dimension 2 Code" := RecGLSetup."Global Dimension 2 Code";
        END;
        IF RecAnalysisView."Dimension 1 Code" = '' THEN
            AccScheduleLine.SETRANGE(AccScheduleLine."Dimension 1 Filter");
        IF RecAnalysisView."Dimension 2 Code" = '' THEN
            AccScheduleLine.SETRANGE(AccScheduleLine."Dimension 2 Filter");
        IF RecAnalysisView."Dimension 3 Code" = '' THEN
            AccScheduleLine.SETRANGE(AccScheduleLine."Dimension 3 Filter");
        IF RecAnalysisView."Dimension 4 Code" = '' THEN
            AccScheduleLine.SETRANGE(AccScheduleLine."Dimension 4 Filter");
        DimensionFilter1 := RecAnalysisView."Dimension 1 Code" <> '';
        DimensionFilter2 := RecAnalysisView."Dimension 2 Code" <> '';
        DimensionFilter3 := RecAnalysisView."Dimension 3 Code" <> '';
        DimensionFilter4 := RecAnalysisView."Dimension 4 Code" <> '';
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, LookUpDimFilterPageAccountSchedule, '', true, true)]
    LOCAL PROCEDURE LookUpDimFilterPageAccountSchedule(AccScheduleLine: Record 85; DimNo: Integer; VAR Text: Text[250]; VAR booldimension: Boolean);
    BEGIN
        booldimension := AccScheduleLine.LookUpDimFilter(DimNo, Text);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, ShowPurchaseJobPItemAvailabilityLines, '', true, true)]
    LOCAL PROCEDURE ShowPurchaseJnlLinePItemAvailabilityLines(VAR Item: Record 27);
    VAR
        needsPurchaseJournalLine: Record 7207281;
        ItemAvailabilityLines: Page 353;
    BEGIN

        needsPurchaseJournalLine.RESET;
        needsPurchaseJournalLine.SETCURRENTKEY(Type, "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                                       "Location Code", "Date Needed");
        needsPurchaseJournalLine.SETRANGE(Type, needsPurchaseJournalLine.Type::Item);
        needsPurchaseJournalLine.SETRANGE("No.", Item."No.");
        needsPurchaseJournalLine.SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
        needsPurchaseJournalLine.SETFILTER("Shortcut Dimension 1 Code", Item.GETFILTER("Global Dimension 1 Filter"));
        needsPurchaseJournalLine.SETFILTER("Shortcut Dimension 2 Code", Item.GETFILTER("Global Dimension 2 Filter"));
        needsPurchaseJournalLine.SETFILTER("Date Needed", Item.GETFILTER("Date Filter"));
        PAGE.RUN(0, needsPurchaseJournalLine);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, DimensionFilterSetRangePageAccScheduleOverview, '', true, true)]
    LOCAL PROCEDURE DimensionFilterSetRangePageAccScheduleOverview(VAR AccScheduleLine: Record 85; codeJobFilter: Code[20]; AnalysisView: Record 363);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF NOT FunctionQB.AccessToQuobuilding THEN
            EXIT;

        IF codeJobFilter <> '' THEN BEGIN
            IF AnalysisView."Dimension 1 Code" = FunctionQB.ReturnDimJobs THEN
                AccScheduleLine.SETRANGE("Dimension 1 Filter", codeJobFilter);
            IF AnalysisView."Dimension 2 Code" = FunctionQB.ReturnDimJobs THEN
                AccScheduleLine.SETRANGE("Dimension 2 Filter", codeJobFilter);
            IF AnalysisView."Dimension 3 Code" = FunctionQB.ReturnDimJobs THEN
                AccScheduleLine.SETRANGE("Dimension 3 Filter", codeJobFilter);
            IF AnalysisView."Dimension 4 Code" = FunctionQB.ReturnDimJobs THEN
                AccScheduleLine.SETRANGE("Dimension 4 Filter", codeJobFilter);
        END;

        AccScheduleLine.SETRANGE("G/L Budget Filter", FunctionQB.ReturnBudgetJobs);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 136 Cab Alb Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 136, OnAfterActionEvent, QB_Anular, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_Anular_PG136(VAR Rec: Record 120);
    VAR
        PurchRcptHeader: Record 120;
        // Cancellationofoutsshipments: Report 7207399;
        Text50000: TextConst ESP = 'Ya ha anulado este albar�n completamente';
    BEGIN
        //JAV 04/04/21: - QB 1.08.32 Se pasa la acci�n de anular desde la page a la CU de Pages
        //                Permite cancelar cualquier albar�n, no solo los FRI
        //                Permite cancelar albaranes parcialmente facturados

        IF Rec.Cancelled THEN
            ERROR(Text50000);

        PurchRcptHeader.RESET;
        PurchRcptHeader.SETRANGE("No.", Rec."No.");

        // CLEAR(Cancellationofoutsshipments);
        // Cancellationofoutsshipments.SETTABLEVIEW(PurchRcptHeader);
        // Cancellationofoutsshipments.RUNMODAL;  //JAV 11/07/22: - QB 1.11.00 Se cambia a RunModal para que no salga el bot�n de programaci�n
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 137 Lin Alb Compra"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Page, 137, OnBeforeActionEvent, Action1900546304, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_Anular_PG137(VAR Rec: Record 121);
    VAR
        // Cancellationofoutsshipments: Report 7207399;
        Text50000: TextConst ESP = 'Ya ha anulado esta l�nea del albar�n';
        FunctionQB: Codeunit 7207272;
        Text50001: TextConst ESP = 'No hay cantidad que cancelar';
    BEGIN
        //JAV 04/04/21: - QB 1.08.32 Para QuoBuilding se usa la rutina propia de anulaci�n

        IF (FunctionQB.AccessToQuobuilding) THEN BEGIN
            IF Rec.Cancelled THEN
                ERROR(Text50000);
            IF Rec.Quantity = 0 THEN
                ERROR(Text50001);

            // CLEAR(Cancellationofoutsshipments);
            // Cancellationofoutsshipments.CancelLine(Rec, TRUE);
        END;
    END;

    // [EventSubscriber(ObjectType::Page, 137, OnAfterActionEvent, Action1900546304, true, true)]
    LOCAL PROCEDURE OnAfterActionEvent_Anular_PG137(VAR Rec: Record 121);
    VAR
        Text50000: TextConst ESP = 'Ya ha anulado este albar�n completamente';
        docNo: Code[20];
    BEGIN
        //JAV 04/04/21: - QB 1.08.32 Para que muestre de nuevo todas las l�neas
        docNo := Rec."Document No.";
        Rec.RESET;
        Rec.SETRANGE("Document No.", docNo);
    END;

    [EventSubscriber(ObjectType::Page, 137, OnBeforeActionEvent, ItemInvoiceLines, true, true)]
    LOCAL PROCEDURE PG137_OnAfterActionEvent_ItemInvoiceLinesQB(VAR Rec: Record 121);
    VAR
        TempPurchInvLine: Record 123 TEMPORARY;
        PurchInvLine: Record 123;
        HasReceipt: Boolean;
    BEGIN
        //Q13614
        IF (Rec.Type = Rec.Type::Item) THEN    //Las de producto dejamos que sea el est�ndar el que las trate
            EXIT;

        TempPurchInvLine.RESET;
        TempPurchInvLine.DELETEALL;
        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Receipt No.", Rec."Document No.");
        PurchInvLine.SETRANGE("Receipt Line No.", Rec."Line No.");
        IF PurchInvLine.FINDSET THEN BEGIN
            REPEAT
                TempPurchInvLine := PurchInvLine;
                IF TempPurchInvLine.INSERT THEN
                    HasReceipt := TRUE;
            UNTIL PurchInvLine.NEXT = 0;
            IF (HasReceipt) THEN
                PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines", TempPurchInvLine);
        END;

        IF (NOT HasReceipt) THEN BEGIN
            PurchInvLine.RESET;
            PurchInvLine.SETRANGE("Order No.", Rec."Order No.");
            PurchInvLine.SETRANGE("Order Line No.", Rec."Order Line No.");
            PurchInvLine.SETRANGE("No.", Rec."No.");
            IF PurchInvLine.FINDSET THEN BEGIN
                REPEAT
                    TempPurchInvLine := PurchInvLine;
                    IF TempPurchInvLine.INSERT THEN
                        HasReceipt := TRUE;
                UNTIL PurchInvLine.NEXT = 0;
                IF (HasReceipt) THEN BEGIN
                    MESSAGE('No encuentro l�neas del albar�n en las facturas, muestro todas las facturas del pedido.');
                    PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines", TempPurchInvLine);
                END;
            END;
        END;

        ERROR(''); //Para que no siga con el proceso est�ndar que dar� un error si no es producto
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 344 Navigate"();
    BEGIN
    END;

    PROCEDURE IncludeQuoBuildingDocumentsPageNavigate(VAR Rec: Record 265 TEMPORARY; DocNoFilter: Code[250]; PostingDateFilter: Text[250]; VAR WorksheetHeaderHist: Record 7207292; VAR HistMeasurements: Record 7207338; VAR PostCertifications: Record 7207341; VAR HistProdMeasureHeader: Record 7207401; VAR PostedOutputShipmentHeader: Record 7207310; VAR HistReestimationHeader: Record 7207317; VAR CostsheetHeaderHist: Record 7207435; VAR HistExpenseNotesHeader: Record 7207323; VAR PostedHeaTCostsInvoices: Record 7207288; VAR HistHeadDelivRetElement: Record 7207359; VAR UsageHeaderHist: Record 7207365; VAR ActivationHeaderHist: Record 7207370; VAR RentalElementsEntries: Record 7207345);
    VAR
        Navigate: Page 344;
    BEGIN
        //Incluir los documentos propios de QuoBuilding en la Navegaci�n de documentos
        //JAV 03/04/21: - Se a�aden movimientos de salidas de almac�n de los alabranes de compra

        IF WorksheetHeaderHist.READPERMISSION THEN BEGIN
            WorksheetHeaderHist.RESET;
            WorksheetHeaderHist.SETCURRENTKEY("No.");
            WorksheetHeaderHist.SETFILTER("No.", DocNoFilter);
            WorksheetHeaderHist.SETFILTER("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Worksheet Header Hist.", Enum::"Document Entry Document Type".FromInteger(0), WorksheetHeaderHist.TABLECAPTION, WorksheetHeaderHist.COUNT);
        END;

        IF HistMeasurements.READPERMISSION THEN BEGIN
            HistMeasurements.RESET;
            HistMeasurements.SETCURRENTKEY("No.");
            HistMeasurements.SETFILTER("No.", DocNoFilter);
            HistMeasurements.SETFILTER("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Hist. Measurements", Enum::"Document Entry Document Type".FromInteger(0), HistMeasurements.TABLECAPTION, HistMeasurements.COUNT);
        END;

        IF PostCertifications.READPERMISSION THEN BEGIN
            PostCertifications.RESET;
            PostCertifications.SETCURRENTKEY("No.");
            PostCertifications.SETFILTER("No.", DocNoFilter);
            PostCertifications.SETFILTER("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Post. Certifications", Enum::"Document Entry Document Type".FromInteger(0), PostCertifications.TABLECAPTION, PostCertifications.COUNT);
        END;

        IF HistProdMeasureHeader.READPERMISSION THEN BEGIN
            HistProdMeasureHeader.RESET;
            HistProdMeasureHeader.SETCURRENTKEY("No.");
            HistProdMeasureHeader.SETFILTER("No.", DocNoFilter);
            HistProdMeasureHeader.SETFILTER("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Hist. Prod. Measure Header",Enum::"Document Entry Document Type".FromInteger(0), HistProdMeasureHeader.TABLECAPTION, HistProdMeasureHeader.COUNT);
        END;

        IF PostedOutputShipmentHeader.READPERMISSION THEN BEGIN
            PostedOutputShipmentHeader.RESET;
            PostedOutputShipmentHeader.SETCURRENTKEY("No.");
            PostedOutputShipmentHeader.SETFILTER("No.", DocNoFilter);
            PostedOutputShipmentHeader.SETFILTER("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Posted Output Shipment Header", Enum::"Document Entry Document Type".FromInteger(0), PostedOutputShipmentHeader.TABLECAPTION, PostedOutputShipmentHeader.COUNT);
            IF (PostedOutputShipmentHeader.COUNT = 0) THEN BEGIN
                //JAV 03/04/21: - Se a�aden movimientos de salidas de almac�n de los albaranes de compra
                PostedOutputShipmentHeader.RESET;
                PostedOutputShipmentHeader.SETCURRENTKEY("Purchase Rcpt. No.", "Posting Date");
                PostedOutputShipmentHeader.SETFILTER("Purchase Rcpt. No.", DocNoFilter);
                PostedOutputShipmentHeader.SETFILTER("Posting Date", PostingDateFilter);
                Navigate.InsertIntoDocEntry(Rec, DATABASE::"Posted Output Shipment Header", Enum::"Document Entry Document Type".FromInteger(1), PostedOutputShipmentHeader.TABLECAPTION, PostedOutputShipmentHeader.COUNT);
            END;
            IF (PostedOutputShipmentHeader.COUNT = 0) THEN BEGIN
                //si tenemos albaranes de consumo que se han generado desde ventas los mostramos.
                PostedOutputShipmentHeader.RESET;
                PostedOutputShipmentHeader.SETCURRENTKEY("Sales Document No.", "Posting Date");
                PostedOutputShipmentHeader.SETFILTER("Sales Document No.", DocNoFilter);
                PostedOutputShipmentHeader.SETFILTER("Posting Date", PostingDateFilter);
                Navigate.InsertIntoDocEntry(Rec, DATABASE::"Posted Output Shipment Header", Enum::"Document Entry Document Type".FromInteger(2), PostedOutputShipmentHeader.TABLECAPTION, PostedOutputShipmentHeader.COUNT);
            END;
        END;

        IF HistReestimationHeader.READPERMISSION THEN BEGIN
            HistReestimationHeader.RESET;
            HistReestimationHeader.SETCURRENTKEY(HistReestimationHeader."No.");
            HistReestimationHeader.SETFILTER(HistReestimationHeader."No.", DocNoFilter);
            HistReestimationHeader.SETFILTER(HistReestimationHeader."Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Hist. Reestimation Header", Enum::"Document Entry Document Type".FromInteger(0), HistReestimationHeader.TABLECAPTION, HistReestimationHeader.COUNT);
        END;

        IF CostsheetHeaderHist.READPERMISSION THEN BEGIN
            CostsheetHeaderHist.RESET;
            CostsheetHeaderHist.SETCURRENTKEY(CostsheetHeaderHist."No.");
            CostsheetHeaderHist.SETFILTER(CostsheetHeaderHist."No.", DocNoFilter);
            CostsheetHeaderHist.SETFILTER(CostsheetHeaderHist."Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Costsheet Header Hist.", Enum::"Document Entry Document Type".FromInteger(0), CostsheetHeaderHist.TABLECAPTION, CostsheetHeaderHist.COUNT);
        END;

        IF HistExpenseNotesHeader.READPERMISSION THEN BEGIN
            HistExpenseNotesHeader.RESET;
            HistExpenseNotesHeader.SETCURRENTKEY(HistExpenseNotesHeader."No.");
            HistExpenseNotesHeader.SETFILTER(HistExpenseNotesHeader."No.", DocNoFilter);
            HistExpenseNotesHeader.SETFILTER(HistExpenseNotesHeader."Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Hist. Expense Notes Header", Enum::"Document Entry Document Type".FromInteger(0), HistExpenseNotesHeader.TABLECAPTION, HistExpenseNotesHeader.COUNT);
        END;

        IF PostedHeaTCostsInvoices.READPERMISSION THEN BEGIN
            PostedHeaTCostsInvoices.RESET;
            PostedHeaTCostsInvoices.SETCURRENTKEY(PostedHeaTCostsInvoices."No.");
            PostedHeaTCostsInvoices.SETFILTER("No.", DocNoFilter);
            PostedHeaTCostsInvoices.SETFILTER("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Tran. Between Jobs Post Header", Enum::"Document Entry Document Type".FromInteger(0), PostedHeaTCostsInvoices.TABLECAPTION, PostedHeaTCostsInvoices.COUNT);
        END;

        IF HistHeadDelivRetElement.READPERMISSION THEN BEGIN
            HistHeadDelivRetElement.RESET;
            HistHeadDelivRetElement.SETCURRENTKEY(HistHeadDelivRetElement."No.");
            HistHeadDelivRetElement.SETFILTER(HistHeadDelivRetElement."No.", DocNoFilter);
            HistHeadDelivRetElement.SETFILTER(HistHeadDelivRetElement."Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Hist. Head. Deliv/Ret. Element", Enum::"Document Entry Document Type".FromInteger(0), HistHeadDelivRetElement.TABLECAPTION, HistHeadDelivRetElement.COUNT);
        END;

        IF UsageHeaderHist.READPERMISSION THEN BEGIN
            UsageHeaderHist.RESET;
            UsageHeaderHist.SETCURRENTKEY(UsageHeaderHist."No.");
            UsageHeaderHist.SETFILTER(UsageHeaderHist."No.", DocNoFilter);
            UsageHeaderHist.SETFILTER(UsageHeaderHist."Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Usage Header Hist.", Enum::"Document Entry Document Type".FromInteger(0), UsageHeaderHist.TABLECAPTION, UsageHeaderHist.COUNT);
        END;

        IF ActivationHeaderHist.READPERMISSION THEN BEGIN
            ActivationHeaderHist.RESET;
            ActivationHeaderHist.SETCURRENTKEY(ActivationHeaderHist."No.");
            ActivationHeaderHist.SETFILTER(ActivationHeaderHist."No.", DocNoFilter);
            ActivationHeaderHist.SETFILTER(ActivationHeaderHist."Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Activation Header Hist.", Enum::"Document Entry Document Type".FromInteger(0), ActivationHeaderHist.TABLECAPTION, ActivationHeaderHist.COUNT);
        END;

        IF RentalElementsEntries.READPERMISSION THEN BEGIN
            RentalElementsEntries.RESET;
            RentalElementsEntries.SETCURRENTKEY("Document No.", "Posting Date");
            RentalElementsEntries.SETFILTER("Document No.", DocNoFilter);
            RentalElementsEntries.SETFILTER("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(Rec, DATABASE::"Rental Elements Entries", Enum::"Document Entry Document Type".FromInteger(0), RentalElementsEntries.TABLECAPTION, RentalElementsEntries.COUNT);
        END;
    END;

    [EventSubscriber(ObjectType::Page, 344, OnAfterGetDocumentCount, '', true, true)]
    PROCEDURE OnAfterGetDocumentCount_pg344(VAR DocCount: Integer);
    VAR
        navigate: Page 344;
    BEGIN
        DocCount += navigate.QB_NoOfRecords(DATABASE::"Worksheet Header Hist.") +
                    navigate.QB_NoOfRecords(DATABASE::"Hist. Measurements") +
                    navigate.QB_NoOfRecords(DATABASE::"Post. Certifications") +
                    navigate.QB_NoOfRecords(DATABASE::"Hist. Prod. Measure Header") +
                    navigate.QB_NoOfRecords(DATABASE::"Posted Output Shipment Header") +
                    navigate.QB_NoOfRecords(DATABASE::"Hist. Reestimation Header") +
                    navigate.QB_NoOfRecords(DATABASE::"Costsheet Header Hist.") +
                    navigate.QB_NoOfRecords(DATABASE::"Hist. Expense Notes Header") +
                    navigate.QB_NoOfRecords(DATABASE::"Tran. Between Jobs Post Header") +
                    navigate.QB_NoOfRecords(DATABASE::"Hist. Head. Deliv/Ret. Element") +
                    navigate.QB_NoOfRecords(DATABASE::"Usage Header Hist.") +
                    navigate.QB_NoOfRecords(DATABASE::"Activation Header Hist.") +
                    navigate.QB_NoOfRecords(DATABASE::"Rental Elements Entries");
    END;

    PROCEDURE ShowGLEntriesFromExpenseNoteCodePageNavigate(VAR Rec: Record 265 TEMPORARY; VAR GLEntry2: Record 17; GLEntry: Record 17; DocNoFilter: Code[250]; PostingDateFilter: Text[250]);
    VAR
        navigate: Page 344;
        Text025BIS: TextConst ENU = '" Generated by Invoice in Expense Notes"', ESP = '" Generados por fact. en notas de gasto"';
    BEGIN
        //Incluimos aqui una llamada para mostrar movimientos contable donde su N� de documento es la factura que se
        //genero desde notas de gasto, pero que pertenecen todos a una misma nota de gasto.
        IF GLEntry2.READPERMISSION THEN BEGIN
            GLEntry2.RESET;
            GLEntry2.SETCURRENTKEY("QB Expense Note Code", "Posting Date");
            GLEntry2.SETFILTER("QB Expense Note Code", DocNoFilter);
            GLEntry2.SETFILTER("Posting Date", PostingDateFilter);
            navigate.InsertIntoDocEntry(Rec, DATABASE::"G/L Entry", Enum::"Document Entry Document Type".FromInteger(77), GLEntry.TABLECAPTION + Text025BIS, GLEntry2.COUNT);
        END;
    END;

    PROCEDURE ShowVendorLedgEntriesFromExpenseNoteCodePageNavigate(VAR Rec: Record 265 TEMPORARY; VAR VendLedgEntry2: Record 25; DocNoFilter: Code[250]; PostingDateFilter: Text[250]);
    VAR
        Text025BIS: TextConst ENU = '" Generated by Invoice in Expense Notes"', ESP = '" Generados por fact. en notas de gasto"';
        navigate: Page 344;
    BEGIN
        IF VendLedgEntry2.READPERMISSION THEN BEGIN
            VendLedgEntry2.RESET;
            VendLedgEntry2.SETCURRENTKEY("QB Expense Note Code", "Posting Date");
            VendLedgEntry2.SETFILTER("QB Expense Note Code", DocNoFilter);
            VendLedgEntry2.SETFILTER("Posting Date", PostingDateFilter);
            navigate.InsertIntoDocEntry(Rec, DATABASE::"Vendor Ledger Entry", Enum::"Document Entry Document Type".FromInteger(77), VendLedgEntry2.TABLECAPTION + Text025BIS, VendLedgEntry2.COUNT);
        END;
    END;

    PROCEDURE ShowDtlVendorLedgEntriesFromExpenseNoteCodePageNavigate(VAR Rec: Record 265 TEMPORARY; VAR DtlVendorLedgentry2: Record 380; DocNoFilter: Code[250]; PostingDateFilter: Text[250]);
    VAR
        Text025BIS: TextConst ENU = '" Generated by Invoice in Expense Notes"', ESP = '" Generados por fact. en notas de gasto"';
        navigate: Page 344;
    BEGIN
        IF DtlVendorLedgentry2.READPERMISSION THEN BEGIN
            DtlVendorLedgentry2.RESET;
            DtlVendorLedgentry2.SETCURRENTKEY("QB Expense Note Code", "Posting Date");
            DtlVendorLedgentry2.SETFILTER("QB Expense Note Code", DocNoFilter);
            DtlVendorLedgentry2.SETFILTER("Posting Date", PostingDateFilter);
            navigate.InsertIntoDocEntry(Rec, DATABASE::"Detailed Vendor Ledg. Entry", Enum::"Document Entry Document Type".FromInteger(77), DtlVendorLedgentry2.TABLECAPTION + Text025BIS, DtlVendorLedgentry2.COUNT);
        END;
    END;

    PROCEDURE ShowJobLedgerEntryFromExpenseNoteCodePageNavigate(VAR Rec: Record 265 TEMPORARY; VAR JobLedgerEntry2: Record 169; DocNoFilter: Code[250]; PostingDateFilter: Text[250]; CarteraDocNoFilter: Text[250]);
    VAR
        navigate: Page 344;
        Text025BIS: TextConst ENU = '" Generated by Invoice in Expense Notes"', ESP = '" Generados por fact. en notas de gasto"';
    BEGIN
        IF JobLedgerEntry2.READPERMISSION AND (CarteraDocNoFilter = '') THEN BEGIN
            JobLedgerEntry2.RESET;
            JobLedgerEntry2.SETCURRENTKEY("Expense Notes Code", "Posting Date");
            JobLedgerEntry2.SETFILTER("Expense Notes Code", DocNoFilter);
            JobLedgerEntry2.SETFILTER("Posting Date", PostingDateFilter);
            navigate.InsertIntoDocEntry(Rec, DATABASE::"Job Ledger Entry", Enum::"Document Entry Document Type".FromInteger(77), JobLedgerEntry2.TABLECAPTION + Text025BIS, JobLedgerEntry2.COUNT);
        END;
    END;

    PROCEDURE ShowDetailedJobLedgEntriesPageNavigate(VAR Rec: Record 265 TEMPORARY; VAR QBDetailedJobLedgerEntry: Record 7207328; DocNoFilter: Code[250]; PostingDateFilter: Text[250]);
    VAR
        Text025BIS: TextConst ENU = '" Generated by Invoice in Expense Notes"', ESP = '" Generados por fact. en notas de gasto"';
        navigate: Page 344;
    BEGIN
        IF QBDetailedJobLedgerEntry.READPERMISSION THEN BEGIN
            QBDetailedJobLedgerEntry.RESET;
            QBDetailedJobLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date");
            QBDetailedJobLedgerEntry.SETFILTER("Document No.", DocNoFilter);
            QBDetailedJobLedgerEntry.SETFILTER("Posting Date", PostingDateFilter);
            navigate.InsertIntoDocEntry(Rec, DATABASE::"QB Detailed Job Ledger Entry", Enum::"Document Entry Document Type".FromInteger(0), QBDetailedJobLedgerEntry.TABLECAPTION, QBDetailedJobLedgerEntry.COUNT);
        END;
    END;

    PROCEDURE VendorLedgerEntrySetSourcePageNavigate(VendLedgerEntry2: Record 25);
    VAR
        navigate: Page 344;
    BEGIN
        IF VendLedgerEntry2.FINDFIRST THEN
            navigate.QB_SetSource(
            VendLedgerEntry2."Posting Date", FORMAT(VendLedgerEntry2."Document Type"), VendLedgerEntry2."Document No.",
            2, VendLedgerEntry2."Vendor No.");
    END;

    PROCEDURE DtlVendorLedgerEntrySetSourcePageNavigate(DtlVendorLedgEntry2: Record 380);
    VAR
        navigate: Page 344;
    BEGIN
        IF DtlVendorLedgEntry2.FINDFIRST THEN
            navigate.QB_SetSource(
              DtlVendorLedgEntry2."Posting Date", FORMAT(DtlVendorLedgEntry2."Document Type"), DtlVendorLedgEntry2."Document No.",
              2, DtlVendorLedgEntry2."Vendor No.");
    END;

    PROCEDURE RentalElementEntriesSetSourcePageNavigate(VAR RentalElementEntry: Record 7207345);
    VAR
        navigate: Page 344;
    BEGIN
        IF navigate.QB_NoOfRecords(DATABASE::"Rental Elements Entries") = 1 THEN BEGIN
            RentalElementEntry.FINDFIRST;
            navigate.QB_SetSource(
              RentalElementEntry."Posting Date", FORMAT(RentalElementEntry."Entry Type"), RentalElementEntry."Document No.",
              1, RentalElementEntry."Element No.");
        END;
    END;

    PROCEDURE RunGLEntryPageNavigate(VAR GLEntry: Record 17; VAR GLEntry2: Record 17; VAR DocumentEntry: Record 265);
    BEGIN
        IF (DocumentEntry."Document Type".AsInteger() = 77) THEN  // = DocumentEntry."Document Type"::"Expense Note":
            PAGE.RUN(0, GLEntry2)
        ELSE
            PAGE.RUN(0, GLEntry);
    END;

    PROCEDURE RunVendLedgEntryPageNavigate(VAR VendLedgEntry: Record 25; VAR VendLedgEntry2: Record 25; VAR DocumentEntry: Record 265);
    BEGIN
        IF (DocumentEntry."Document Type".AsInteger() = 77) THEN  // = DocumentEntry."Document Type"::"Expense Note":
            PAGE.RUN(0, VendLedgEntry2)
        ELSE
            PAGE.RUN(0, VendLedgEntry);
    END;

    PROCEDURE RunDtldVendorLedgEntryPageNavigate(VAR DtlVendLedgEntry: Record 380; VAR DtlVendLedgEntry2: Record 380; VAR DocumentEntry: Record 265);
    BEGIN
        IF (DocumentEntry."Document Type".AsInteger() = 77) THEN  // = DocumentEntry."Document Type"::"Expense Note":
            PAGE.RUN(0, DtlVendLedgEntry2)
        ELSE
            PAGE.RUN(0, DtlVendLedgEntry);
    END;

    PROCEDURE RunGLJobLedgerEntryNavigate(VAR JobLedgerEntry: Record 169; VAR JobLedgerEntry2: Record 169; VAR DocumentEntry: Record 265);
    BEGIN
        IF (DocumentEntry."Document Type".AsInteger() = 77) THEN  // = DocumentEntry."Document Type"::"Expense Note":
            PAGE.RUN(0, JobLedgerEntry2)
        ELSE
            PAGE.RUN(0, JobLedgerEntry);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 357"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 357, OnAfterActionEvent, CopyCompany, true, true)]
    LOCAL PROCEDURE P357_OnAfterActionEvent_CopyCompany(VAR Rec: Record 2000000006);
    BEGIN
        MESSAGE('Recuerde marcar la nueva empresa como empresa de prueba si es necesario');
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 490"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 490, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PAccScheduleOverview(VAR Rec: Record 85);
    VAR
        CJobFilter: Code[20];
        AnalysisView: Record 363;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF NOT FunctionQB.AccessToQuobuilding THEN
            EXIT;

        IF CJobFilter <> '' THEN BEGIN    // TO-DO Nunca toma valor, revisar su uso
            IF AnalysisView."Dimension 1 Code" = FunctionQB.ReturnDimJobs THEN
                Rec.SETRANGE("Dimension 1 Filter", CJobFilter);
            IF AnalysisView."Dimension 2 Code" = FunctionQB.ReturnDimJobs THEN
                Rec.SETRANGE("Dimension 2 Filter", CJobFilter);
            IF AnalysisView."Dimension 3 Code" = FunctionQB.ReturnDimJobs THEN
                Rec.SETRANGE("Dimension 3 Filter", CJobFilter);
            IF AnalysisView."Dimension 4 Code" = FunctionQB.ReturnDimJobs THEN
                Rec.SETRANGE("Dimension 4 Filter", CJobFilter);
        END;

        Rec.SETRANGE("G/L Budget Filter", FunctionQB.ReturnBudgetJobs);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 537"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 537, OnAfterActionEvent, "QB_Value-Indent", true, true)]
    LOCAL PROCEDURE "P537_OnAfterActionEvent_Value-Indent"(VAR Rec: Record 349);
    VAR
        DimensionValue: Record 349;
        TL: ARRAY[20] OF Integer;
        i: Integer;
        l: Integer;
    BEGIN
        //JAV 15/04/21: - QB 1.08.39 Indentar usando longitud del registro si no tiene inicio-fin total

        //Miro si hay alguno indentado, si es asi no hago nada
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Rec."Dimension Code");
        DimensionValue.SETFILTER(Indentation, '<>0');
        IF (NOT DimensionValue.ISEMPTY) THEN
            EXIT;

        //Monto la tabla de longitudes
        CLEAR(TL);
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Rec."Dimension Code");
        IF (DimensionValue.FINDSET) THEN
            REPEAT
                TL[STRLEN(DimensionValue.Code)] := STRLEN(DimensionValue.Code);
            UNTIL (DimensionValue.NEXT = 0);

        //Ajusto la tabla de longitudes para que sean correlativas
        l := 0;
        FOR i := 1 TO ARRAYLEN(TL) DO BEGIN
            IF (TL[i] <> 0) THEN BEGIN
                TL[i] := l;
                l += 1;
            END;
        END;

        //Asocio la indentaci�n
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Rec."Dimension Code");
        IF (DimensionValue.FINDSET) THEN
            REPEAT
                DimensionValue.Indentation := TL[STRLEN(DimensionValue.Code)];
                DimensionValue.MODIFY;
            UNTIL (DimensionValue.NEXT = 0);
    END;

    [EventSubscriber(ObjectType::Page, 537, OnAfterActionEvent, "QB_Value-Indent_Void", true, true)]
    LOCAL PROCEDURE "P537_OnAfterActionEvent_Value-Indent_Void"(VAR Rec: Record 349);
    VAR
        DimensionValue: Record 349;
        TL: ARRAY[20] OF Integer;
        i: Integer;
        l: Integer;
    BEGIN
        //JAV 15/04/21: - QB 1.08.39 Quitar la Indentaci�n

        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Rec."Dimension Code");
        DimensionValue.MODIFYALL(Indentation, 0);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 1002"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Page, 1002, OnBeforeActionEvent, QB_CalculateAnalyticalBudget, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_CalculateAnalyticBudgetItem_PJobTaskLines(VAR Rec: Record 1001);
    VAR
        Job: Record 167;
        JobPostingGroup: Record 208;
        JobGroupSetupAC: Code[10];
        JobPlanningLine: Record 1003;
        DimJob1: Boolean;
        DimJob2: Boolean;
        DimJob3: Boolean;
        DimJob4: Boolean;
        varDimJob: Code[20];
        varDimBudgetJob: Code[20];
        GLBudgetEntry: Record 96;
        GLBudgetName: Record 95;
        InvoiceMilestone: Record 7207331;
        NoEntry: Integer;
        LineCount: Integer;
        Window: Dialog;
        FunctionQB: Codeunit 7207272;
        Text003: TextConst ENU = 'Procedure cannot be executed because there are Postings without "Analytical Concepts"', ESP = 'No se puede ejecutar la operaci�n porque existen registros sin "Conceptos Anal�ticos"';
        Text004: TextConst ESP = '� Quiere cambiar el presupuesto por concepto anal�tico por el creado en el presupuesto por items ?';
        Text007: TextConst ENU = 'completed procedure', ESP = 'Proceso terminado.';
        Text008: TextConst ENU = 'Cancelled Procedure', ESP = 'Proceso cancelado.';
        Text009: TextConst ENU = 'Posting entries        #2######\', ESP = 'Registrando movs.        #2######\';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            Job.GET(Rec."Job No.");
            Job.TESTFIELD("Job Posting Group");
            JobPostingGroup.GET(Job."Job Posting Group");
            JobPostingGroup.TESTFIELD("Sales Analytic Concept");
            JobGroupSetupAC := JobPostingGroup."Sales Analytic Concept";
            JobPlanningLine.RESET;
            JobPlanningLine.SETRANGE(JobPlanningLine."Job No.", Rec."Job No.");
            IF JobPlanningLine.FIND('-') THEN
                REPEAT
                    IF JobPlanningLine."Analytical concept" = '' THEN
                        ERROR(Text003);
                UNTIL JobPlanningLine.NEXT = 0;

            //Pedimos confirmaci�n de la acci�n
            IF CONFIRM(Text004) THEN BEGIN
                Window.OPEN(
                  '#1#################################\\' +
                  Text009);
                Window.UPDATE(1, STRSUBSTNO('%1', Job."No."));
                //vamos a recorrer los mov.presupuesto y localizamos la dimensi�n donde se copia el proyecto para eliminar sus l�neas
                IF Job.Status = Job.Status::Planning THEN BEGIN
                    varDimJob := FunctionQB.ReturnDimQuote;
                    varDimBudgetJob := FunctionQB.ReturnBudgetQuote;
                END ELSE BEGIN
                    varDimJob := FunctionQB.ReturnDimJobs;
                    varDimBudgetJob := FunctionQB.ReturnBudgetJobs;
                END;

                DimJob1 := FALSE;
                DimJob2 := FALSE;
                DimJob3 := FALSE;
                DimJob4 := FALSE;
                GLBudgetEntry.RESET;
                GLBudgetName.RESET;
                GLBudgetName.GET(varDimBudgetJob);
                IF GLBudgetName."Budget Dimension 1 Code" = varDimJob THEN BEGIN
                    DimJob1 := TRUE;
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Dimension 1 Code", Rec."Job No.");
                END;
                IF GLBudgetName."Budget Dimension 2 Code" = varDimJob THEN BEGIN
                    DimJob2 := TRUE;
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Dimension 2 Code", Rec."Job No.");
                END;
                IF GLBudgetName."Budget Dimension 3 Code" = varDimJob THEN BEGIN
                    DimJob3 := TRUE;
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Dimension 3 Code", Rec."Job No.");
                END;
                IF GLBudgetName."Budget Dimension 4 Code" = varDimJob THEN BEGIN
                    DimJob4 := TRUE;
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Dimension 4 Code", Rec."Job No.");
                END;

                DeleteEntryBudget(GLBudgetEntry);

                JobPlanningLine.RESET;
                JobPlanningLine.SETRANGE(JobPlanningLine."Job No.", Rec."Job No.");
                IF JobPlanningLine.FIND('-') THEN
                    REPEAT
                        InsertLinBudgetG(GLBudgetEntry, varDimBudgetJob, JobPlanningLine,
                                         DimJob1, DimJob2, DimJob3, DimJob4, Rec, Job, LineCount);
                        InvoiceMilestone.RESET;
                        InvoiceMilestone.SETRANGE("Job No.", Rec."Job No.");
                        IF NOT InvoiceMilestone.FIND('-') THEN BEGIN
                            InsertLinBudgetI(GLBudgetEntry, JobGroupSetupAC, DimJob1, DimJob2, DimJob3, DimJob4, Rec, Job,
                                             LineCount, JobPlanningLine, varDimBudgetJob);
                        END;
                    UNTIL JobPlanningLine.NEXT = 0;
                InvoiceMilestone.RESET;
                InvoiceMilestone.SETRANGE("Job No.", Rec."Job No.");
                IF InvoiceMilestone.FIND('-') THEN BEGIN
                    REPEAT
                        InvoiceMilestone.CALCFIELDS(Comments);
                        CLEAR(GLBudgetEntry);
                        GLBudgetEntry."Entry No." := NoEntryBudget(GLBudgetEntry);
                        GLBudgetEntry."Budget Name" := varDimBudgetJob;
                        //vamos a comprobar cual es el valor de la dim. del concepto anal�tico
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                            GLBudgetEntry.VALIDATE("Global Dimension 1 Code", JobGroupSetupAC);
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                            GLBudgetEntry.VALIDATE("Global Dimension 2 Code", JobGroupSetupAC);

                        // el n� de cuenta se trae en funci�n del tipo y varia seg�n sea Ingreso o cuenta//
                        //GLBudgetEntry."G/L Account No.":= //FunTraeCtaImpVenta;

                        IF InvoiceMilestone."Completion Date" <> 0D THEN
                            GLBudgetEntry.Date := InvoiceMilestone."Completion Date"
                        ELSE BEGIN
                            InvoiceMilestone.TESTFIELD("Estimated Date");
                            GLBudgetEntry.Date := InvoiceMilestone."Estimated Date";
                        END;

                        GLBudgetEntry.Amount := -InvoiceMilestone.Amount;
                        GLBudgetEntry.Description := InvoiceMilestone.Comments;

                        IF DimJob1 THEN
                            GLBudgetEntry.VALIDATE("Budget Dimension 1 Code", Rec."Job No.");
                        IF DimJob2 THEN
                            GLBudgetEntry.VALIDATE("Budget Dimension 2 Code", Rec."Job No.");
                        IF DimJob3 THEN
                            GLBudgetEntry.VALIDATE("Budget Dimension 3 Code", Rec."Job No.");
                        IF DimJob4 THEN
                            GLBudgetEntry.VALIDATE("Budget Dimension 4 Code", Rec."Job No.");

                        Job.GET(Rec."Job No.");
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
                            Job.TESTFIELD(Job."Global Dimension 1 Code");
                            GLBudgetEntry.VALIDATE("Global Dimension 1 Code", Job."Global Dimension 1 Code");
                        END ELSE BEGIN
                            Job.TESTFIELD(Job."Global Dimension 2 Code");
                            GLBudgetEntry.VALIDATE("Global Dimension 2 Code", Job."Global Dimension 2 Code");
                        END;
                        IF GLBudgetEntry.Amount <> 0 THEN
                            GLBudgetEntry.INSERT(TRUE);

                        LineCount := LineCount + 1;
                        Window.UPDATE(2, LineCount);
                    UNTIL InvoiceMilestone.NEXT = 0;
                END;
                MESSAGE(Text007);
                Window.CLOSE;
            END ELSE
                MESSAGE(Text008);
        END;
    END;

    LOCAL PROCEDURE DeleteEntryBudget(VAR GLBudgetEntry: Record 96);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN

        IF GLBudgetEntry.FINDSET THEN
            REPEAT
                GLBudgetEntry.DELETE;
            UNTIL GLBudgetEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertLinBudgetG(VAR GLBudgetEntry: Record 96; varDimBudgetJob: Code[20]; JobPlanningLine: Record 1003; DimJob1: Boolean; DimJob2: Boolean; DimJob3: Boolean; DimJob4: Boolean; VAR JobTask: Record 1001; VAR Job: Record 167; VAR LineCount: Integer);
    VAR
        recValorDim: Record 349;
        varValorDim: Text[20];
        recProducto: Record 27;
        recGCP: Record 251;
        recConfGCP: Record 252;
        recRecurso: Record 156;
        recFamilia: Record 152;
        NoEntry: Integer;
        FunctionQB: Codeunit 7207272;
        Window: Dialog;
    BEGIN
        //[hay que insertar en la tabla de mov.presupuestos dos registros por cada lin.ppto.proy. una con ca de gastos e importe de coste y
        //otra con un ca de ingresos e importe de venta]
        CLEAR(GLBudgetEntry);
        GLBudgetEntry."Entry No." := NoEntryBudget(GLBudgetEntry);
        GLBudgetEntry."Budget Name" := varDimBudgetJob;

        //vamos a comprobar cual es el valor de la dim. del concepto anal�tico
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
            GLBudgetEntry.VALIDATE("Global Dimension 1 Code", JobPlanningLine."Analytical concept");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
            GLBudgetEntry.VALIDATE("Global Dimension 2 Code", JobPlanningLine."Analytical concept");

        // el n� de cuenta se trae en funci�n del tipo y varia seg�n sea Ingreso o cuenta//
        GLBudgetEntry."G/L Account No." := GetAccAmountCost(JobPlanningLine);

        GLBudgetEntry.Date := JobPlanningLine."Planning Date";
        GLBudgetEntry.Amount := JobPlanningLine."Total Cost (LCY)";
        GLBudgetEntry.Description := JobPlanningLine.Description;

        IF DimJob1 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 1 Code", JobTask."Job No.");
        IF DimJob2 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 2 Code", JobTask."Job No.");
        IF DimJob3 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 3 Code", JobTask."Job No.");
        IF DimJob4 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 4 Code", JobTask."Job No.");

        Job.GET(JobTask."Job No.");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN BEGIN
            Job.TESTFIELD(Job."Global Dimension 1 Code");
            GLBudgetEntry.VALIDATE("Global Dimension 1 Code", Job."Global Dimension 1 Code");
        END ELSE BEGIN
            Job.TESTFIELD(Job."Global Dimension 2 Code");
            GLBudgetEntry.VALIDATE("Global Dimension 2 Code", Job."Global Dimension 2 Code");
        END;

        IF GLBudgetEntry.Amount <> 0 THEN
            GLBudgetEntry.INSERT(TRUE);

        LineCount := LineCount + 1;
        Window.UPDATE(2, LineCount);
    END;

    LOCAL PROCEDURE InsertLinBudgetI(VAR GLBudgetEntry: Record 96; JobGroupSetupAC: Code[10]; DimJob1: Boolean; DimJob2: Boolean; DimJob3: Boolean; DimJob4: Boolean; VAR JobTask: Record 1001; VAR Job: Record 167; VAR LineCount: Integer; JobPlanningLine: Record 1003; varDimBudgetJob: Code[20]);
    VAR
        recValorDim: Record 349;
        varValorDim: Text[20];
        FunctionQB: Codeunit 7207272;
        Window: Dialog;
    BEGIN

        //[hay que insertar en la tabla de mov.presupuestos dos registros por cada lin.ppto.proy. una con ca de gastos e importe de coste y
        //otra con un ca de ingresos e importe de venta]

        CLEAR(GLBudgetEntry);
        GLBudgetEntry."Entry No." := NoEntryBudget(GLBudgetEntry);
        GLBudgetEntry."Budget Name" := varDimBudgetJob;

        //vamos a comprobar cual es el valor de la dim. del concepto anal�tico
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
            GLBudgetEntry.VALIDATE("Global Dimension 1 Code", JobGroupSetupAC);
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
            GLBudgetEntry.VALIDATE("Global Dimension 2 Code", JobGroupSetupAC);

        // el n� de cuenta se trae en funci�n del tipo y varia seg�n sea Ingreso o cuenta//
        GLBudgetEntry."G/L Account No." := GetAccAmountSale(JobGroupSetupAC, JobPlanningLine);

        GLBudgetEntry.Date := JobPlanningLine."Planning Date";
        GLBudgetEntry.Amount := -JobPlanningLine."Total Price (LCY)";
        GLBudgetEntry.Description := JobPlanningLine.Description;

        IF DimJob1 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 1 Code", JobTask."Job No.");
        IF DimJob2 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 2 Code", JobTask."Job No.");
        IF DimJob3 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 3 Code", JobTask."Job No.");
        IF DimJob4 THEN
            GLBudgetEntry.VALIDATE("Budget Dimension 4 Code", JobTask."Job No.");

        Job.GET(JobTask."Job No.");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
            Job.TESTFIELD(Job."Global Dimension 1 Code");
            GLBudgetEntry.VALIDATE("Global Dimension 1 Code", Job."Global Dimension 1 Code");
        END ELSE BEGIN
            Job.TESTFIELD(Job."Global Dimension 2 Code");
            GLBudgetEntry.VALIDATE("Global Dimension 2 Code", Job."Global Dimension 2 Code");
        END;

        IF GLBudgetEntry.Amount <> 0 THEN
            GLBudgetEntry.INSERT(TRUE);

        LineCount := LineCount + 1;
        Window.UPDATE(2, LineCount);
    END;

    PROCEDURE GetAccAmountSale(JobGroupSetupAC: Code[10]; JobPlanningLine: Record 1003): Code[20];
    VAR
        recDimValue: Record 349;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //++HP para Importe venta se le asocia la cuenta venta del Grupo contable proyecto
        IF JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" THEN BEGIN
            IF JobPlanningLine."Total Cost (LCY)" = 0 THEN
                EXIT(JobPlanningLine."No.");
        END;

        IF recDimValue.GET(FunctionQB.ReturnDimCA, JobGroupSetupAC) THEN
            EXIT(recDimValue."Account Budget E Reestimations");
    END;

    LOCAL PROCEDURE GetAccAmountCost(JobPlanningLine: Record 1003): Code[20];
    VAR
        recDimValue: Record 349;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" THEN BEGIN
            IF JobPlanningLine."Total Cost (LCY)" <> 0 THEN
                EXIT(JobPlanningLine."No.");
        END;

        IF recDimValue.GET(FunctionQB.ReturnDimCA, JobPlanningLine."Analytical concept") THEN
            EXIT(recDimValue."Account Budget E Reestimations");
    END;

    LOCAL PROCEDURE NoEntryBudget(VAR GLBudgetEntry: Record 96): Integer;
    BEGIN
        GLBudgetEntry.RESET;
        IF GLBudgetEntry.FINDLAST THEN
            EXIT(GLBudgetEntry."Entry No." + 1)
        ELSE
            EXIT(1);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- PG 5116"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Page, 5116, OnBeforeActionEvent, Objectives, true, true)]
    PROCEDURE ActionObjectives_Pg5116(VAR Rec: Record 13);
    VAR
        VendorsObjective: Record 50009;
        VendorsObjectiveList: Page 50012;
    BEGIN
        VendorsObjective.RESET;
        VendorsObjective.SETRANGE("Vendor No.", Rec.Code);
        VendorsObjectiveList.SETTABLEVIEW(VendorsObjective);
        VendorsObjectiveList.RUNMODAL;
    END;

    LOCAL PROCEDURE "PG 1351,10765,10766,10767 Cambios en documentos registrados"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Page, 1351, OnBeforeChangeDocument, '', true, true)]
    PROCEDURE PG1351_OnBeforeChangeDocument(Rec: Record 122);
    VAR
        PurchInvHeader: Record 122;
        VendorLedgerEntry: Record 25;
        QBCodeunitSubscriber: Codeunit 7207353;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 06/07/22: - QB 1.10.59 Esta funci�n maneja los cambios en Facturas de compra Regitradas, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
        PurchInvHeader.GET(Rec."No.");
        IF (Rec."Do not send to SII" = PurchInvHeader."Do not send to SII") AND
           (Rec."On Hold" = PurchInvHeader."On Hold") AND
           //(Rec."QuoSII Auto Posting Date" = PurchInvHeader."QuoSII Auto Posting Date") AND  //JAV 12/07/22: - QB 1.11.00 Se pasan campos del QuoSII a su CU
           (Rec."QB Payment Bank No." = PurchInvHeader."QB Payment Bank No.") THEN  //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco
            EXIT;

        //Cambiar factura y movimientos de proveedor asociados si cambia esperar
        IF (Rec."On Hold" <> PurchInvHeader."On Hold") THEN BEGIN
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETCURRENTKEY("Document No.");
            VendorLedgerEntry.SETRANGE("Document No.", Rec."No.");
            VendorLedgerEntry.SETRANGE("Vendor No.", Rec."Buy-from Vendor No.");
            VendorLedgerEntry.SETRANGE(Open, TRUE);
            VendorLedgerEntry.SETFILTER("Document Situation", '%1|%2', VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera);
            VendorLedgerEntry.MODIFYALL("On Hold", Rec."On Hold");
        END;

        //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco de cobro y el cambio en los movimientos
        //EPV 30/03/22: - QB 1.10.29 (Bug) - Al registrar �rdenes de pago no modifica el movimiento de proveedor. JAV 31/03/22 Se modifica el arreglo por cambios posteriores, se a�ade par�metro
        QBCodeunitSubscriber.ChangeVendorBank(Rec."No.", Rec."QB Payment Bank No.", PurchInvHeader."QB Payment Bank No.", TRUE, FALSE); //JAV 24/11/21: - QB 1.10.01 Cambiar los movimientos

        //JAV 13/05/21: - QB 1.08.42 Cambiar datos de las facturas de compra registradas
        PurchInvHeader.GET(Rec."No.");
        PurchInvHeader."Do not send to SII" := Rec."Do not send to SII";
        PurchInvHeader."On Hold" := Rec."On Hold";
        //PurchInvHeader."QuoSII Auto Posting Date" := Rec."QuoSII Auto Posting Date";   //JAV 12/07/22: - QB 1.11.00 Se pasan campos del QuoSII a su CU
        PurchInvHeader."QB Payment Bank No." := Rec."QB Payment Bank No.";
        PurchInvHeader.MODIFY;
    END;

    // [EventSubscriber(ObjectType::Page, 10767, OnBeforeChangeDocument, '', true, true)]
    PROCEDURE PG10767_OnBeforeChangeDocument(Rec: Record 124);
    VAR
        PurchCrMemoHdr: Record 124;
        VendorLedgerEntry: Record 25;
        QBCodeunitSubscriber: Codeunit 7207353;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 06/07/22: - QB 1.10.59 Esta funci�n maneja los cambios en Abonos de compra Regitrados, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
        PurchCrMemoHdr.GET(Rec."No.");
        IF (Rec."Do not send to SII" = PurchCrMemoHdr."Do not send to SII") AND
           (Rec."QB Payment Bank No." = PurchCrMemoHdr."QB Payment Bank No.") THEN  //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco
            EXIT;

        //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco de cobro y el cambio en los movimientos
        //EPV 30/03/22: - QB 1.10.29 (Bug) - Al registrar �rdenes de pago no modifica el movimiento de proveedor. JAV 31/03/22 Se modifica el arreglo por cambios posteriores, se a�ade par�metro
        QBCodeunitSubscriber.ChangeVendorBank(Rec."No.", Rec."QB Payment Bank No.", PurchCrMemoHdr."QB Payment Bank No.", TRUE, FALSE); //JAV 24/11/21: - QB 1.10.01 Cambiar los movimientos

        //JAV 13/05/21: - QB 1.08.42 Cambiar datos de abonos de compra registradas
        PurchCrMemoHdr.GET(Rec."No.");
        PurchCrMemoHdr."Do not send to SII" := Rec."Do not send to SII";
        PurchCrMemoHdr."QB Payment Bank No." := Rec."QB Payment Bank No.";
        PurchCrMemoHdr.MODIFY;
    END;

    // [EventSubscriber(ObjectType::Page, 10765, OnBeforeChangeDocument, '', true, true)]
    PROCEDURE PG10765_OnBeforeChangeDocument(Rec: Record 112);
    VAR
        SalesInvoiceHeader: Record 112;
        QBCodeunitSubscriber: Codeunit 7207353;
        WithholdingTreating: Codeunit 7207306;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 06/07/22: - QB 1.10.59 Esta funci�n maneja los cambios en Facturas de venta Regitradas, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
        SalesInvoiceHeader.GET(Rec."No.");
        IF (Rec."Do not send to SII" = SalesInvoiceHeader."Do not send to SII") AND
           (Rec."QW Witholding Due Date" = SalesInvoiceHeader."QW Witholding Due Date") AND
           (Rec."External Document No." = SalesInvoiceHeader."External Document No.") AND
           (Rec."Payment bank No." = SalesInvoiceHeader."Payment bank No.") THEN  //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco
            EXIT;

        //Actualizar el vto de la retenci�n
        IF (Rec."QW Witholding Due Date" <> SalesInvoiceHeader."QW Witholding Due Date") THEN
            WithholdingTreating.UpdateWithholdingDueDate(Rec."No.", Rec."Posting Date", Rec."QW Witholding Due Date", TRUE);

        //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco de cobro y el cambio en los movimientos
        //EPV 30/03/22: - QB 1.10.29 (Bug) - Al registrar �rdenes de pago no modifica el movimiento de proveedor. JAV 31/03/22 Se modifica el arreglo por cambios posteriores, se a�ade par�metro
        QBCodeunitSubscriber.ChangeCustomerBank(Rec."No.", Rec."Payment bank No.", SalesInvoiceHeader."Payment bank No.", TRUE, FALSE); //JAV 24/11/21: - QB 1.10.01 Cambiar los movimientos

        //JAV 13/05/21: - QB 1.08.42 Cambiar datos de facturas de venta registradas
        SalesInvoiceHeader.GET(Rec."No.");
        SalesInvoiceHeader."Do not send to SII" := Rec."Do not send to SII";
        SalesInvoiceHeader."QW Witholding Due Date" := Rec."QW Witholding Due Date";
        SalesInvoiceHeader."External Document No." := Rec."External Document No.";
        SalesInvoiceHeader."Payment bank No." := Rec."Payment bank No.";
        SalesInvoiceHeader.MODIFY;
    END;

    // [EventSubscriber(ObjectType::Page, 10766, OnBeforeChangeDocument, '', true, true)]
    PROCEDURE PG10766_OnBeforeChangeDocument(Rec: Record 114);
    VAR
        SalesCrMemoHeader: Record 114;
        QBCodeunitSubscriber: Codeunit 7207353;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 06/07/22: - QB 1.10.59 Esta funci�n maneja los cambios en Abonos de venta Regitrados, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
        SalesCrMemoHeader.GET(Rec."No.");
        IF (Rec."Do not send to SII" = SalesCrMemoHeader."Do not send to SII") AND
           (Rec."Payment bank No." = SalesCrMemoHeader."Payment bank No.") THEN  //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco
            EXIT;

        //JAV 24/11/21: - QB 1.10.01 Se a�ade el banco de pago y el cambio en los movimientos
        //EPV 30/03/22: - QB 1.10.29 (Bug) - Al registrar �rdenes de pago no modifica el movimiento de proveedor. JAV 31/03/22 Se modifica el arreglo por cambios posteriores, se a�ade par�metro
        QBCodeunitSubscriber.ChangeCustomerBank(Rec."No.", Rec."Payment bank No.", SalesCrMemoHeader."Payment bank No.", TRUE, FALSE); //JAV 24/11/21: - QB 1.10.01 Cambiar los movimientos

        //JAV 13/05/21: - QB 1.08.42 Cambiar datos de abonos de venta registrados
        SalesCrMemoHeader.GET(Rec."No.");
        SalesCrMemoHeader."Do not send to SII" := Rec."Do not send to SII";
        SalesCrMemoHeader."Payment bank No." := Rec."Payment bank No.";
        SalesCrMemoHeader.MODIFY;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- 7207436"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 7207436, OnBeforeActionEvent, ArchivarContrato, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_ArchiveContract_PElementContractHeader(VAR Rec: Record 7207353);
    VAR
        Text001: TextConst ENU = 'Document %1 has been archived.', ESP = 'Se ha archivado el Documento %1.';
        Text010: TextConst ENU = 'Archive lease: %1?', ESP = '�Archivar el contrato de alquiler: %1 ?';
    BEGIN
        IF CONFIRM(
          Text010, TRUE, Rec."No.")
        THEN BEGIN
            StoreContrato(Rec, FALSE);
            Rec.DELETE(TRUE);
            MESSAGE(Text001, Rec."No.");
        END;
    END;

    LOCAL PROCEDURE StoreContrato(VAR ElementContractHeader: Record 7207353; InteractionExist: Boolean);
    VAR
        ElementContractLines: Record 7207354;
        Text011: TextConst ENU = 'Can not archive contract% 1 because there are lines with quantity to return', ESP = 'No es posible archivar el contrato %1 porque existen l�neas con cantidad pediente de devolver';
        HistElementContractHeader: Record 7207373;
        HistElementContractLine: Record 7207374;
    BEGIN
        ElementContractLines.SETRANGE("Document No.", ElementContractHeader."No.");
        IF ElementContractLines.FINDSET THEN
            REPEAT
                ElementContractLines.CALCFIELDS("Delivered Quantity", ElementContractLines."Return Quantity");
                IF ElementContractLines."Delivered Quantity" <> ElementContractLines."Return Quantity" THEN
                    ERROR(Text011, ElementContractHeader."No.");
            UNTIL ElementContractLines.NEXT = 0;


        CLEAR(HistElementContractHeader);
        HistElementContractHeader.TRANSFERFIELDS(ElementContractHeader);
        HistElementContractHeader."Archive by" := USERID;
        HistElementContractHeader."Date Archived" := WORKDATE;
        HistElementContractHeader."Time Archived" := TIME;
        HistElementContractHeader."Dimension Set ID" := ElementContractHeader."Dimension Set ID";
        HistElementContractHeader.INSERT;
        ElementContractLines.SETRANGE("Document No.", ElementContractHeader."No.");
        IF ElementContractLines.FINDSET THEN
            REPEAT
                CLEAR(HistElementContractLine);
                HistElementContractLine.TRANSFERFIELDS(ElementContractLines);
                HistElementContractLine."Delivered Quantity" := ElementContractLines."Dimension Set ID";
                HistElementContractLine.INSERT;
            UNTIL ElementContractLines.NEXT = 0;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Filter Access Level Purchases"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 53, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPurchaseList(VAR Rec: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchasesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 49, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPurchaseQuote(VAR Rec: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchasesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 509, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PBlanketPurchaseOrder(VAR Rec: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchasesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 50, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPurchaseOrder(VAR Rec: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchasesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 51, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPurchaseInvoice(VAR Rec: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchasesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 52, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPurchaseCreditMemo(VAR Rec: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchasesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 136, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedPurchaseReceipt(VAR Rec: Record 120);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchRcptHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 145, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedPurchaseReceiptList(VAR Rec: Record 120);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchRcptHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 138, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedPurchaseInvoice(VAR Rec: Record 122);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchInvHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 146, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedPurchaseInvoicesList(VAR Rec: Record 122);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchInvHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 140, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedPurchaseCreditMemo(VAR Rec: Record 124);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchCrMemoHdrFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 147, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedPurchaseCreditMemosList(VAR Rec: Record 124);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobPurchCrMemoHdrFilter(Rec);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Filter Access Level Sales"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 45, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PSalesList(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 41, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PSalesQuote(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 507, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PBlanketSalesOrder(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 42, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PSalesOrder(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 43, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PSalesInvoice(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 44, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PSalesCreditMemo(VAR Rec: Record 36);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 130, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedSalesShipment(VAR Rec: Record 110);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesShipmentHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 142, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedSalesShipmentList(VAR Rec: Record 110);
    VAR
        codefilterlevel: Code[250];
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesShipmentHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 132, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedSalesInvoice(VAR Rec: Record 112);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesInvoiceHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 143, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedSalesInvoiceList(VAR Rec: Record 112);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesInvoiceHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 134, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedSsalesCreditMemo(VAR Rec: Record 114);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesCrMemoHeaderFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 144, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOpenPageEvent_PPostedSalesCreditMemoList(VAR Rec: Record 114);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobSalesCrMemoHeaderFilter(Rec);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Filter Access Level Other"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 92, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOPenPageFilterAccessLevelPJobLedgerEntries(VAR Rec: Record 169);
    VAR
        codefilterlevel: Code[250];
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobsJobLedgerEntryFilter(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 202, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnOPenPageFilterAccessLevelPResourceLedgerEntries(VAR Rec: Record 203);
    VAR
        codefilterlevel: Code[250];
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetUserJobsResLedgerEntryFilter(Rec);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- 72,76,77"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 72, OnBeforeActionEvent, QB_GetTransferCost, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_QBGetTransferCost_PResourceGroup(VAR Rec: Record 152);
    VAR
        RecGroup: Record 152;
        recTranferPriceCost: Record 7207299;
        pagetransfer: Page 7207282;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            RecGroup.RESET;
            CLEAR(pagetransfer);
            RecGroup.GET(Rec."No.");
            recTranferPriceCost.SETRANGE(Type, recTranferPriceCost.Type::"Group(Resource)");
            recTranferPriceCost.SETRANGE(Code, RecGroup."No.");
            pagetransfer.SETTABLEVIEW(recTranferPriceCost);
            pagetransfer.RUNMODAL;
        END;
    END;

    [EventSubscriber(ObjectType::Page, 76, OnBeforeActionEvent, QB_GetTransferCost, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_QBGetTransferCost_PResourceCard(VAR Rec: Record 156);
    VAR
        PriceCost: Record 7207299;
        FunctionQB: Codeunit 7207272;
    BEGIN
        PriceCost.RESET;
        PriceCost.SETRANGE(PriceCost.Type, PriceCost.Type::Resource);
        PriceCost.SETRANGE(Code, Rec."No.");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
            PriceCost.SETFILTER("Cod. Dept.", '<>%1', Rec."Global Dimension 1 Code");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
            PriceCost.SETFILTER("Cod. Dept.", '<>%1', Rec."Global Dimension 2 Code");
        PAGE.RUN(7207282, PriceCost);
    END;

    // [EventSubscriber(ObjectType::Page, 77, OnBeforeActionEvent, QB_GetTransferCost, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_QBGetTransferCost_PResourceList(VAR Rec: Record 156);
    VAR
        PriceCost: Record 7207299;
        FunctionQB: Codeunit 7207272;
    BEGIN
        PriceCost.RESET;
        PriceCost.SETRANGE(PriceCost.Type, PriceCost.Type::Resource);
        PriceCost.SETRANGE(Code, Rec."No.");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
            PriceCost.SETFILTER("Cod. Dept.", '<>%1', Rec."Global Dimension 1 Code");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
            PriceCost.SETFILTER("Cod. Dept.", '<>%1', Rec."Global Dimension 2 Code");
        PAGE.RUN(7207282, PriceCost);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Estudios y Proyectos"();
    BEGIN
    END;

    PROCEDURE seeBudgetByCA(Job: Record 167; pAll: Boolean);
    VAR
        Text005: TextConst ENU = 'It does not exist in conf. of accounting for the job budget dimension a job dimension value.', ESP = 'No existe en conf. de contabilidad para la dimensi�n de presupuesto de proyecto un valor de dimensi�n de  proyecto';
        Text004: TextConst ENU = 'The field %1 must have a value to be able to budget by analytical concept.', ESP = 'El campo %1 debe de tener un valor para poder presupuestar por concepto anal�tico.';
        DimensionCodeBuffer: Record 367;
        GLBudgetName: Record 95;
        FunctionQB: Codeunit 7207272;
        BudgetbyCA: Page 7207279;
        DimJob: Code[20];
        DimBudgetJob: Code[20];
        DimReest: Code[20];
        Version: Boolean;
        JobRange: Text;
        VersionRange: Text;
    BEGIN
        //JAV 05/03/21: QB 1.08.21 Presenta la pantalla de comparaci�n de versiones

        ERROR('Opci�n en desarrollo, no operativa en este momento');
        IF (pAll) THEN BEGIN
            IF (Job."Original Quote Code" = '') THEN BEGIN
                JobRange := Job."No." + '-..';
                VersionRange := Job."No." + '-00..' + Job."No." + '-99';
            END ELSE BEGIN
                JobRange := Job."Original Quote Code" + '-..';
                VersionRange := Job."Original Quote Code" + '-00..' + Job."Original Quote Code" + '-99';
            END;
        END ELSE BEGIN
            JobRange := Job."No.";
            VersionRange := Job."No.";
        END;

        CASE Job."Card Type" OF
            Job."Card Type"::Estudio:
                BEGIN
                    DimJob := FunctionQB.ReturnDimQuote;
                    DimBudgetJob := FunctionQB.ReturnBudgetQuote;
                END;
            Job."Card Type"::"Proyecto operativo":
                BEGIN
                    DimJob := FunctionQB.ReturnDimJobs;
                    DimBudgetJob := FunctionQB.ReturnBudgetJobs;
                END;
        END;
        DimReest := FunctionQB.ReturnDimReest;

        // para llevar el filtro de reestimaci�n tenemos en cuenta que este es su nombre y no se puede cambiar y que se
        // encuentra en la (tabla 95 conf. en la budget dim 2 code) por eso lo colacamos directamente en el 2
        // el cual lo asignamos all� donde se localice el proyecto, excepto en la dim 2, pues ya sabemos que por ahi no va a pasar

        DimensionCodeBuffer.RESET;

        GLBudgetName.RESET;
        GLBudgetName.GET(DimBudgetJob);

        CASE TRUE OF
            GLBudgetName."Budget Dimension 1 Code" = DimJob:
                DimensionCodeBuffer.SETRANGE("Dimension 1 Value Filter", JobRange);
            GLBudgetName."Budget Dimension 2 Code" = DimJob:
                DimensionCodeBuffer.SETRANGE("Dimension 2 Value Filter", JobRange);
            GLBudgetName."Budget Dimension 3 Code" = DimJob:
                DimensionCodeBuffer.SETRANGE("Dimension 3 Value Filter", JobRange);
            GLBudgetName."Budget Dimension 4 Code" = DimJob:
                DimensionCodeBuffer.SETRANGE("Dimension 4 Value Filter", JobRange);
            ELSE
                ERROR(Text005);  //se controla que la Dimensi�n de estudios exista en alguna de las columnas del preuspuesto
        END;

        IF (Job."Latest Reestimation Code" <> '') THEN
            CASE TRUE OF
                GLBudgetName."Budget Dimension 1 Code" = DimReest:
                    DimensionCodeBuffer.SETRANGE("Dimension 2 Value Filter", Job."Latest Reestimation Code");
                GLBudgetName."Budget Dimension 2 Code" = DimReest:
                    DimensionCodeBuffer.SETRANGE("Dimension 2 Value Filter", Job."Latest Reestimation Code");
                GLBudgetName."Budget Dimension 3 Code" = DimReest:
                    DimensionCodeBuffer.SETRANGE("Dimension 2 Value Filter", Job."Latest Reestimation Code");
                GLBudgetName."Budget Dimension 4 Code" = DimReest:
                    DimensionCodeBuffer.SETRANGE("Dimension 2 Value Filter", Job."Latest Reestimation Code");
            END;

        CLEAR(BudgetbyCA);

        CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) OF
            1:
                BEGIN
                    IF Job."Global Dimension 1 Code" = '' THEN
                        ERROR(Text004, Job.FIELDCAPTION("Global Dimension 1 Code"));
                    BudgetbyCA.GetJob(VersionRange, Job."Global Dimension 1 Code", Job."Latest Reestimation Code")
                END;
            2:
                BEGIN
                    IF Job."Global Dimension 2 Code" = '' THEN
                        ERROR(Text004, Job.FIELDCAPTION("Global Dimension 2 Code"));
                    BudgetbyCA.GetJob(VersionRange, Job."Global Dimension 2 Code", Job."Latest Reestimation Code");
                END;
        END;

        IF (Job."Card Type" = Job."Card Type"::Estudio) THEN BEGIN
            Version := TRUE;
            BudgetbyCA.FIsVersion(Version);
            BudgetbyCA.Contract(Version);
        END;
        BudgetbyCA.RUNMODAL;
    END;

    PROCEDURE TJob_SeeMilestone(Job: Record 167);
    VAR
        InvoiceMilestone: Record 7207331;
        InvoiceMilestoneList: Page 7207329;
    BEGIN
        InvoiceMilestone.RESET;
        InvoiceMilestone.SETRANGE(InvoiceMilestone."Job No.", Job."No.");

        CLEAR(InvoiceMilestoneList);
        InvoiceMilestoneList.SETTABLEVIEW(InvoiceMilestone);
        InvoiceMilestoneList.RUNMODAL;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Proyectos operativos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 7207477, OnBeforeActionEvent, Job_Schema, true, true)]
    LOCAL PROCEDURE PG7207477_OnBeforeActionEvent_Job_Schema(VAR Rec: Record 167);
    BEGIN
        //JAV 11/03/21: - QB 1.08.23 Se pasa la ejecuci�n de esta acci�n desde la p�gina "lista de proyectos operativos"
        JobSchema(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 7207478, OnBeforeActionEvent, Job_Schema, true, true)]
    LOCAL PROCEDURE PG7207478_OnBeforeActionEvent_Job_Schema(VAR Rec: Record 167);
    BEGIN
        //JAV 11/03/21: - QB 1.08.23 Se pasa la ejecuci�n de esta acci�n desde la p�gina "ficha del proyecto operativo"
        JobSchema(Rec);
    END;

    LOCAL PROCEDURE JobSchema(Rec: Record 167);
    VAR
        QuoBuildingSetup: Record 7207278;
        AccSche: Page 490;
    BEGIN
        //JAV 11/03/21: - QB 1.08.23 Se unifica la ejecuci�n de la acci�n del Esquema del Proyecto de la p�gina de lista y de la p�gina de ficha de proyectos operativos
        QuoBuildingSetup.GET;

        CLEAR(AccSche);
        AccSche.SetAccSchedName(QuoBuildingSetup."Acc. Sched. Name for Job");
        AccSche.SetDimFilters(3, Rec."No.");
        AccSche.QB_SetEditable(FALSE);
        AccSche.RUNMODAL;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Varios"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, PurchaseContractPrint, '', true, true)]
    LOCAL PROCEDURE PurchaseContractPrint(DocumentType: Option; DocumentNo: Code[20]);
    VAR
        PurchasesPayablesSetup: Record 312;
        PurchaseHeader: Record 38;
        QBReportSelections: Record 7206901;
    BEGIN
        //JAV 14/03/19: - Se unifica y simplifica en una sola funci�n el codigo de impresi�n de contratos de compra, as� no repite c�digo

        //QB_2137 Imprimir el informe adecuado seg�n los importes configurados (Sin IVA)

        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE(PurchaseHeader."Document Type", DocumentType);
        PurchaseHeader.SETRANGE(PurchaseHeader."No.", DocumentNo);
        PurchaseHeader.FINDFIRST;
        PurchaseHeader.CALCFIELDS(Amount);

        //JAV 03/10/19: - Se utiliza el nuevo selector de informes para la impresi�n
        QBReportSelections.PrintAmount(QBReportSelections.Usage::P1, PurchaseHeader, PurchaseHeader.Amount);

        // PurchasesPayablesSetup.GET();
        // IF PurchaseHeader.Amount <= PurchasesPayablesSetup."Supply Ticket Amount To" THEN BEGIN
        //  PurchasesPayablesSetup.TESTFIELD("Supply Ticket Amount To");
        //  REPORT.RUN(PurchasesPayablesSetup."Supply Ticket Report", TRUE, FALSE,PurchaseHeader);
        // END ELSE IF PurchaseHeader.Amount <= PurchasesPayablesSetup."Purch. Order Amount To" THEN BEGIN
        //  PurchasesPayablesSetup.TESTFIELD("Purch. Order Amount To");
        //  REPORT.RUN(PurchasesPayablesSetup."Purch. Order Report", TRUE, FALSE,PurchaseHeader);
        // END ELSE BEGIN
        //  PurchasesPayablesSetup.TESTFIELD("Contract Report");
        //  REPORT.RUN(PurchasesPayablesSetup."Contract Report", TRUE, FALSE,PurchaseHeader);
        // END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, CopyTextToJob, '', true, true)]
    LOCAL PROCEDURE CopyTextToJob(VAR Sender: Codeunit 7207348; JobNo: Code[20]);
    VAR
        Job: Record 167;
        Piecework: Record 7207277;
        DataPieceworkForProduction: Record 7207386;
        ExtendedTextHeaderOrigen: Record 279;
        ExtendedTextHeaderDestino: Record 279;
        ExtendedTextLineOrigen: Record 280;
        ExtendedTextLineDestino: Record 280;
    BEGIN
        //JAV 08/04/19: - Nueva funci�n para cargar textos del preciario del proyecto
        //JAV 02/10/19: - La funci�n de cargar textos se amplia para cargar los del precios de directos y de indirectos

        Job.GET(JobNo);
        IF (Job."Import Cost Database Direct" = '') AND (Job."Import Cost Database Indirect" = '') THEN
            ERROR('No hay ning�n preciario de origen')
        ELSE BEGIN
            IF (Job."Import Cost Database Direct" <> '') THEN
                CopyTextToJobCostDatabase(JobNo, Job."Import Cost Database Direct");
            IF (Job."Import Cost Database Indirect" <> '') THEN
                CopyTextToJobCostDatabase(JobNo, Job."Import Cost Database Indirect");
            MESSAGE('Textos cargados');
        END;
    END;

    // [EventSubscriber(ObjectType::Codeunit, 7207348, CopyTextToJob, '', true, true)]
    LOCAL PROCEDURE CopyTextToJobCostDatabase(JobNo: Code[20]; CostDatabaseNo: Code[20]);
    VAR
        Job: Record 167;
        Piecework: Record 7207277;
        DataPieceworkForProduction: Record 7207386;
        QBTextOrigen: Record 7206918;
        QBTextDestino: Record 7206918;
    BEGIN
        //JAV 02/10/19: - Se cargan los textos del preciario indicado como par�metro
        //JAV 27/04/20: - Se cambia textox a la nueva tabla
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", CostDatabaseNo);
        IF Piecework.FINDSET(FALSE) THEN
            REPEAT
                IF DataPieceworkForProduction.GET(JobNo, Piecework."No.") THEN BEGIN
                    //Re-Cargar los textos
                    IF QBTextOrigen.GET(QBTextOrigen.Table::Preciario, Piecework."Cost Database Default", Piecework."No.") THEN BEGIN
                        QBTextOrigen.CALCFIELDS("Cost Text", "Sales Text");
                        QBTextDestino := QBTextOrigen;
                        QBTextDestino.Table := QBTextDestino.Table::Job;
                        QBTextDestino.Key1 := JobNo;
                        QBTextDestino.Key2 := DataPieceworkForProduction."Piecework Code";
                        IF NOT QBTextDestino.INSERT THEN;
                    END;
                END;
            UNTIL Piecework.NEXT = 0;
    END;

    PROCEDURE LookUpContrat(VAR pNro: Code[20]);
    VAR
        PurchaseHeader: Record 38;
        PurchaseList: Page 53;
    BEGIN
        PurchaseHeader.RESET;
        PurchaseHeader.SETFILTER("Document Type", '%1|%2', PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Blanket Order");

        CLEAR(PurchaseList);
        PurchaseList.SETTABLEVIEW(PurchaseHeader);
        PurchaseList.LOOKUPMODE(TRUE);
        IF (PurchaseList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            PurchaseList.GETRECORD(PurchaseHeader);
            pNro := PurchaseHeader."No.";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207348, SetJobPageEditable, '', true, true)]
    PROCEDURE SetJobPageEditable(job: Record 167; VAR InternalStatusEditable: Boolean; VAR ChangeInternalStatus: Boolean);
    VAR
        UserSetup: Record 91;
        InternalsStatus: Record 7207440;
        job2: Record 167;
    BEGIN
        //JAV 08/08/19: - Se unifica el calculo del bloqueo en estudios y proyectos creando una nueva funci�n

        InternalStatusEditable := TRUE;
        ChangeInternalStatus := TRUE;

        //Si el estado interno es editable o no
        IF InternalsStatus.GET(job."Card Type", job."Internal Status") THEN
            InternalStatusEditable := InternalStatusEditable AND InternalsStatus."Editable Card";

        //Si est� bloqueado por el usuario
        InternalStatusEditable := InternalStatusEditable AND (job."Budget Status" = job."Budget Status"::Open);
        ChangeInternalStatus := ChangeInternalStatus AND (job."Budget Status" = job."Budget Status"::Open);

        //Busco el usuaro
        IF NOT UserSetup.GET(USERID) THEN BEGIN
            InternalStatusEditable := FALSE;
            ChangeInternalStatus := FALSE;
        END;

        //Si est� bloqueado
        InternalStatusEditable := InternalStatusEditable AND (NOT job."Blocked Quote Version");

        CASE job."Card Type" OF
            job."Card Type"::Estudio:
                BEGIN
                    //Editable seg�n usuario
                    InternalStatusEditable := InternalStatusEditable AND UserSetup."Modify Quote";
                    ChangeInternalStatus := ChangeInternalStatus AND UserSetup."Modify Quote";

                    //No editable si est� aprobado o rechazado
                    InternalStatusEditable := InternalStatusEditable AND (job."Quote Status" = job."Quote Status"::Pending);
                    ChangeInternalStatus := ChangeInternalStatus AND (job."Quote Status" = job."Quote Status"::Pending);

                    //Miramos el padre del estudio
                    IF (job2.GET(job."Original Quote Code")) THEN BEGIN
                        InternalStatusEditable := InternalStatusEditable AND (job2."Budget Status" = job2."Budget Status"::Open);
                        InternalStatusEditable := InternalStatusEditable AND (job2."Quote Status" = job2."Quote Status"::Pending);
                        IF InternalsStatus.GET(job2."Card Type", job2."Internal Status") THEN
                            InternalStatusEditable := InternalStatusEditable AND InternalsStatus."Editable Card";

                        ChangeInternalStatus := ChangeInternalStatus AND (job2."Quote Status" = job2."Quote Status"::Pending);
                    END;
                END;
            job."Card Type"::"Proyecto operativo":
                BEGIN
                    // Se permite o no cambiar el estado interno del proyecto seg�n usuario
                    InternalStatusEditable := InternalStatusEditable AND UserSetup."Modify Job";
                    ChangeInternalStatus := ChangeInternalStatus AND UserSetup."Modify Job Status";

                    //No editable si est� bloqueado
                    InternalStatusEditable := InternalStatusEditable AND (job."Budget Status" = job."Budget Status"::Open);
                END;
        END;
    END;

    PROCEDURE SetBudgetNeedRecalculate(P1: Boolean; P2: Boolean; VAR pSt1: Text; VAR pSt2: Text; VAR pTxt: Text);
    VAR
        Text000: TextConst ENU = 'Ok', ESP = 'Ok';
        Text001: TextConst ENU = 'Need Recalculate', ESP = 'Debe Recalcular';
    BEGIN
        //JAV 30/01/19: - Nueva funci�n SetBudgetNeedReclaculate que estabece los datos necesarios si el presupuesto se debe recalcular
        pSt1 := 'Bold';
        pSt2 := 'Standard';
        pTxt := 'Calculado';
        IF (P1) THEN BEGIN
            pSt1 := 'Unfavorable';
            pSt2 := 'Unfavorable';
            pTxt := 'Debe rec. Presupuesto';
        END ELSE IF (P2) THEN BEGIN
            pSt1 := 'Unfavorable';
            pSt2 := 'Unfavorable';
            pTxt := 'Debe rec. Anal�tico';
        END;
    END;

    PROCEDURE SeeSchedulePieceworks(JobNo: Code[20]; BudgetCode: Code[20]; IsDirect: Boolean);
    VAR
        ExpectedTimeUnitData: Record 7207388;
        TMPExpectedTimeUnitData: Record 7207389;
        DataPieceworkForProduction: Record 7207386;
        DialogWindow: Dialog;
        Text001: TextConst ENU = 'Preparing job unit planning data', ESP = 'Preparando datos de planificaci�n unidad de obra #1####################';
        Text002: TextConst ESP = 'No hay unidades de obra que planificar';
        Fecha: Date;
    BEGIN
        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.");
        TMPExpectedTimeUnitData.SETRANGE("Job No.", JobNo);
        TMPExpectedTimeUnitData.DELETEALL;

        DialogWindow.OPEN(Text001);

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", JobNo);
        DataPieceworkForProduction.SETRANGE("Budget Filter", BudgetCode);
        DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
        DataPieceworkForProduction.SETRANGE(Plannable, TRUE);
        IF (IsDirect) THEN
            DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::Piecework)
        ELSE
            DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::"Cost Unit");

        IF (NOT DataPieceworkForProduction.FINDSET(FALSE)) THEN
            ERROR(Text002)
        ELSE BEGIN
            REPEAT
                DialogWindow.UPDATE(1, DataPieceworkForProduction."Piecework Code");

                ExpectedTimeUnitData.RESET;
                ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                ExpectedTimeUnitData.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Budget Code", BudgetCode);
                IF ExpectedTimeUnitData.FINDSET THEN
                    REPEAT
                        //-Q19564 AML Vamos a poner un solo registro por mes
                        Fecha := DMY2DATE(1, DATE2DMY(ExpectedTimeUnitData."Expected Date", 2), DATE2DMY(ExpectedTimeUnitData."Expected Date", 3));
                        //+Q19564
                        TMPExpectedTimeUnitData.RESET;
                        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code");
                        TMPExpectedTimeUnitData.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                        TMPExpectedTimeUnitData.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                        TMPExpectedTimeUnitData.SETRANGE("Budget Code", BudgetCode);
                        //-Q19564
                        //TMPExpectedTimeUnitData.SETRANGE("Expected Date", ExpectedTimeUnitData."Expected Date");
                        //+Q19564
                        TMPExpectedTimeUnitData.SETRANGE("Expected Date", Fecha);
                        //-Q19564
                        //IF (TMPExpectedTimeUnitData.ISEMPTY) THEN BEGIN
                        IF NOT TMPExpectedTimeUnitData.FINDFIRST THEN BEGIN
                            //+Q19564
                            CLEAR(TMPExpectedTimeUnitData);
                            TMPExpectedTimeUnitData.TRANSFERFIELDS(ExpectedTimeUnitData);
                            //Q16189.CPA 24/01/22.Begin
                            TMPExpectedTimeUnitData."Entry No." := 0;
                            //Q16189.CPA 24/01/22.End
                            TMPExpectedTimeUnitData.SetData;
                            //-Q19564
                            TMPExpectedTimeUnitData."Expected Date" := Fecha;
                            //+Q19564
                            TMPExpectedTimeUnitData.INSERT(FALSE);
                        END ELSE BEGIN
                            TMPExpectedTimeUnitData."Expected Measured Amount" += ExpectedTimeUnitData."Expected Measured Amount";
                            TMPExpectedTimeUnitData.SetData;
                            TMPExpectedTimeUnitData.MODIFY(FALSE);
                        END;
                    UNTIL ExpectedTimeUnitData.NEXT = 0;

            UNTIL DataPieceworkForProduction.NEXT = 0;

            DialogWindow.CLOSE;
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Plan Job Units", DataPieceworkForProduction)
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------ Presupuestos"();
    BEGIN
    END;

    PROCEDURE SeeSchedulePieceworksForBudgets(JobNo: Code[20]; BudgetCode: Code[20]; IsDirect: Boolean);
    VAR
        ExpectedTimeUnitData: Record 7207383;
        TMPExpectedTimeUnitData: Record 7206942;
        DataPieceworkForProduction: Record 7207386;
        DialogWindow: Dialog;
        Text001: TextConst ENU = 'Preparing job unit planning data', ESP = 'Preparando datos de planificaci�n unidad de obra #1####################';
        Text002: TextConst ESP = 'No hay unidades de obra que planificar';
    BEGIN
        //-QPR15703
        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.");
        TMPExpectedTimeUnitData.SETRANGE("Job No.", JobNo);
        TMPExpectedTimeUnitData.DELETEALL;

        DialogWindow.OPEN(Text001);

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", JobNo);
        DataPieceworkForProduction.SETRANGE("Budget Filter", BudgetCode);
        DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
        DataPieceworkForProduction.SETRANGE(Plannable, TRUE);
        IF (IsDirect) THEN
            DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::Piecework)
        ELSE
            DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::"Cost Unit");

        IF (NOT DataPieceworkForProduction.FINDSET(FALSE)) THEN
            ERROR(Text002)
        ELSE BEGIN
            REPEAT
                DialogWindow.UPDATE(1, DataPieceworkForProduction."Piecework Code");

                ExpectedTimeUnitData.RESET;
                ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework code");
                ExpectedTimeUnitData.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                ExpectedTimeUnitData.SETRANGE("Piecework code", DataPieceworkForProduction."Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Budget Code", BudgetCode);
                IF ExpectedTimeUnitData.FINDSET THEN
                    REPEAT
                        TMPExpectedTimeUnitData.RESET;
                        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework code");
                        TMPExpectedTimeUnitData.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                        TMPExpectedTimeUnitData.SETRANGE("Piecework code", DataPieceworkForProduction."Piecework Code");
                        TMPExpectedTimeUnitData.SETRANGE("Budget Code", BudgetCode);
                        //DGG
                        TMPExpectedTimeUnitData.SETRANGE(Type, ExpectedTimeUnitData.Type);

                        TMPExpectedTimeUnitData.SETRANGE("Expected Date", ExpectedTimeUnitData."Expected Date");
                        IF (TMPExpectedTimeUnitData.ISEMPTY) THEN BEGIN
                            CLEAR(TMPExpectedTimeUnitData);
                            TMPExpectedTimeUnitData.TRANSFERFIELDS(ExpectedTimeUnitData);
                            EVALUATE(TMPExpectedTimeUnitData."Expected Date", '01/' + FORMAT(DATE2DMY(TMPExpectedTimeUnitData."Expected Date", 2)) + '/' + FORMAT(DATE2DMY(TMPExpectedTimeUnitData."Expected Date", 3)));
                            TMPExpectedTimeUnitData.SetData;
                            TMPExpectedTimeUnitData.INSERT(FALSE);
                        END ELSE BEGIN
                            //TMPExpectedTimeUnitData."Expected Measured Amount" += ExpectedTimeUnitData."Expected Measured Amount";
                            TMPExpectedTimeUnitData."Cost Amount" += ExpectedTimeUnitData."Cost Amount";
                            TMPExpectedTimeUnitData."Sale Amount" += ExpectedTimeUnitData."Sale Amount";
                            TMPExpectedTimeUnitData.SetData;
                            TMPExpectedTimeUnitData.MODIFY(FALSE);
                        END;
                    UNTIL ExpectedTimeUnitData.NEXT = 0;

            UNTIL DataPieceworkForProduction.NEXT = 0;

            DialogWindow.CLOSE;
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Plan Job Budget Units", DataPieceworkForProduction)
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Operation County/Country"();
    BEGIN
    END;

    PROCEDURE VerifyCounties(pCounties: Text);
    VAR
        PostCode: Record 225;
        i: Integer;
    BEGIN
        //QUONEXT PER 05.06.19: - Elecnor, verificar el contenido del campo de provincias en los que opera
        IF (pCounties <> '') THEN BEGIN
            WHILE pCounties <> '' DO BEGIN
                i := STRPOS(pCounties, '|');
                IF i > 0 THEN BEGIN
                    PostCode.RESET;
                    PostCode.SETRANGE(County, COPYSTR(pCounties, 1, i - 1));
                    PostCode.FINDFIRST;
                    pCounties := COPYSTR(pCounties, i + 1);
                END ELSE BEGIN
                    PostCode.RESET;
                    PostCode.SETRANGE(County, pCounties);
                    PostCode.FINDFIRST;
                    pCounties := '';
                END;
            END;
        END;
    END;

    PROCEDURE GetOperationCounties(VAR pCountries: Text);
    VAR
        PostCode: Record 225;
        pgPostCodes: Page 367;
        txtfiltro: Text;
    BEGIN
        //QUONEXT PER 05.06.19: - Elecnor, assist edit del campo de provincias en los que opera
        PostCode.SETFILTER(County, pCountries);
        CLEAR(pgPostCodes);
        pgPostCodes.SETTABLEVIEW(PostCode);
        pgPostCodes.LOOKUPMODE(TRUE);
        IF (pgPostCodes.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            pgPostCodes.SETSELECTIONFILTER(PostCode);
            txtfiltro := '';
            IF (PostCode.FINDSET) THEN
                REPEAT
                    IF (PostCode.County <> '') AND (STRPOS(txtfiltro, PostCode.County) = 0) THEN BEGIN
                        IF (txtfiltro <> '') THEN
                            txtfiltro += '|';
                        txtfiltro += PostCode.County;
                    END;
                UNTIL PostCode.NEXT = 0;
            pCountries := COPYSTR(txtfiltro, 1, MAXSTRLEN(pCountries));
        END;
    END;

    PROCEDURE VerifyCountries(pCountries: Text);
    VAR
        CountryRegion: Record 9;
        i: Integer;
    BEGIN
        //QUONEXT PER 05.06.19: - Elecnor, verificar el contenido del campo de paises en los que opera
        IF (pCountries <> '') THEN BEGIN
            WHILE pCountries <> '' DO BEGIN
                i := STRPOS(pCountries, '|');
                IF i > 0 THEN BEGIN
                    CountryRegion.GET(COPYSTR(pCountries, 1, i - 1));
                    pCountries := COPYSTR(pCountries, i + 1);
                END ELSE BEGIN
                    CountryRegion.GET(pCountries);
                    pCountries := '';
                END;
            END;
        END;
    END;

    PROCEDURE GetOperationCountries(VAR pCountries: Text);
    VAR
        CountryRegion: Record 9;
        pgCountriesRegions: Page 10;
        txtfiltro: Text;
    BEGIN
        //QUONEXT PER 05.06.19: - Elecnor, assist edit del campo de paises en los que opera
        CountryRegion.SETFILTER(Code, pCountries);
        CLEAR(pgCountriesRegions);
        pgCountriesRegions.SETTABLEVIEW(CountryRegion);
        pgCountriesRegions.LOOKUPMODE(TRUE);
        IF (pgCountriesRegions.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            pgCountriesRegions.SETSELECTIONFILTER(CountryRegion);
            txtfiltro := '';
            IF (CountryRegion.FINDSET) THEN
                REPEAT
                    IF (txtfiltro <> '') THEN
                        txtfiltro += '|';
                    txtfiltro += CountryRegion.Code;
                UNTIL CountryRegion.NEXT = 0;
            pCountries := COPYSTR(txtfiltro, 1, MAXSTRLEN(pCountries));
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------- Repartir gastos"();
    BEGIN
    END;

    PROCEDURE RegularizarGastosGenerales(pJob: Code[20]);
    VAR
        JobLedgerEntry: Record 169;
        JobLedgerEntries: Page 92;
    BEGIN
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETRANGE("Job No.", pJob);
        JobLedgerEntry.SETRANGE("Piecework Indirect Type", TRUE);

        CLEAR(JobLedgerEntries);
        JobLedgerEntries.SETTABLEVIEW(JobLedgerEntry);
        JobLedgerEntries.RUNMODAL;
    END;

    LOCAL PROCEDURE "--------------------------------------------"();
    BEGIN
    END;

    PROCEDURE CopyPricesToJob(JobNo: Code[20]);
    VAR
        Job: Record 167;
        Piecework: Record 7207277;
        DataPieceworkForProduction: Record 7207386;
        ExtendedTextHeaderOrigen: Record 279;
        ExtendedTextHeaderDestino: Record 279;
        ExtendedTextLineOrigen: Record 280;
        ExtendedTextLineDestino: Record 280;
        QBTextOrigen: Record 7206918;
        QBTextDestino: Record 7206918;
    BEGIN
        //JAV 28/09/20: - Nueva funci�n para cargar precios de venta del preciario al proyecto

        Job.GET(JobNo);
        IF (Job."Import Cost Database Direct" = '') THEN
            ERROR('No hay ning�n preciario de origen')
        ELSE BEGIN
            IF (CONFIRM('Confirme que desea volver a cargar los precios de venta del preciario', FALSE)) THEN BEGIN
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", JobNo);
                DataPieceworkForProduction.SETRANGE("Customer Certification Unit", TRUE);
                IF (DataPieceworkForProduction.FINDSET(TRUE)) THEN
                    REPEAT
                        IF (Piecework.GET(Job."Import Cost Database Direct", DataPieceworkForProduction."Piecework Code")) THEN BEGIN
                            DataPieceworkForProduction.VALIDATE("Contract Price", Piecework."Proposed Sale Price");
                            DataPieceworkForProduction.MODIFY;
                        END;
                    UNTIL (DataPieceworkForProduction.NEXT = 0);
                MESSAGE('Precios cargados');
            END;
        END;
    END;

    /*BEGIN
/*{
      JAV 14/03/19: - Se unifica en una sola funci�n PurchaseContractPrint el codigo de impresi�n de contratos de compra, as� no se repite c�digo
                    - Se eliminan las funciones PAG50_OnPrePrint(DocumentType y PAG9307_OnPrePrint que ya no se usan
      JAV 22/03/19: - Se unifican los eventos para imprimir pedidos de compra como contratos en el PurchaseContractPrint y se eliminan los eventos PAG50_OnPrePrint y PAG9307_OnPrePrint
                    - Eventos HistMeasurementsCancel para cancelar una medici�n registrada y PostCertificationsCancel para cancelar una certificaci�n registrada
      JAV 26/03/19: - La propuesta de pasar la medici�n al contrato se hace no solo para subcontratas

      JAV 08/04/19: - Se mejoran los eventos de cancelar medici�n y certificaci�n, no se valida para que no de errores.
                    - Nuevo evento CopyTextToJob para copiar l�neas del preciario al proyecto o estudio
      JAV 11/04/19: - Se pone en la cacelaci�n de la certifiaci�n el mismo nro y texto de certificaci�n que la original
      JAV 15/06/19: - Se a�ade una funci�n para hacer el lookup de un contrato
      JAV 25/07/19: - Evento HistProdMeasureCancel para cancelar una relaci�n valorada registrada
      JAV 18/08/19: - Se elimina el uso de la variable "Estimation type" que no tiene sientido
      JMMA 28/08/19 - Se modifica la cancelaci�n  de la valorada porque hay que poner la medici�n total menos la origen anterior
      JAV 02/10/19: - La funci�n de cargar textos se amplia para cargar los del precios de directos y de indirectos
      JAV 03/10/19: - Se utiliza el nuevo selector de informes para la impresi�n, se elimina la funci�n "PrintContractOLD" que no se utiliza
      JAV 11/10/19: - Se elimina la funci�n "OpenClosePurchaseOrder" y sus relacionadas, pues no hacen nada �til
                          OpenClosePurchaseOrderPagePurchOrder
                          OpenClosePurchaseOrderPagePurchQuote
                          OpenClosePurchaseOrderPagePurchInvoice
                          OpenClosePurchaseOrderPagePurchCreditMemo
                          OpenClosePurchaseOrderPagePurchBlanketOrder
                          OpenClosePurchaseOrderPagePurchReturnOrder
                          OpenOrClosePurchaseOrderPagePurchaseOrder
      JAV 15/10/19: - Se cambia el uso de la variable "Certification Text" que se ha eliminado por "Text Measure"
                    - Se eliminan los campos 14 "Measure Date" y 32 "Certification Date" de las l�neas de medici�n que no se usan
      JAV 23/10/19: - Se eliminan funciones de c�lculos de las retenciones que no se utilizan ya
                          ValidateTotalReceivableWithholdings
                          ValidateTotalReceivableGetVATWithholdingsPurchaseStatistics
                          ValidateTotalReceivableGetVATWithholdingsSalesInvoiceStatistics
                          ValidateTotalReceivableGetVATWithholdingsSalesCrMemoStatistics
                          ValidateTotalReceivableGetVATWithholdingsPurchaseInvoiceStatistics
                          ValidateTotalReceivableGetVATWithholdingsPurchaseCrMemoStatistics
                          ValidateTotalReceivableGetVATWithholdingsSalesOrderStatistics
                          ValidateTotalReceivableGetVATWithholdingsPurchaseOrderStatistics
                    - Se pasa a la CU de retenciones el evento WithholdingMovPagePageGLRegister y la parte de retenciones del evento IncludeQuobuildingWithholdingsAndRentalElementEntriesPageNavigate
                      renombrando este a IncludeQuobuildingRentalElementEntriesPageNavigate
      JAV 11/12/19: - Se mejora en la funci�n SetJobPageEditable el bloqueo de edici�n de las fichas de estudio y proyecto
      JAV 30/01/19: - Nueva funci�n SetBudgetNeedReclaculate que estabece los datos necesarios si el presupuesto se debe recalcular
      JAV 29/02/20: - Nueva funci�n OnOpenPage88, al abrir la p�gina estandar de proyecto si este viene desde QuoBuilding abre la pantalla apropiada y cierra la estandar
      JAV 19/03/20: - Se cambia el uso de campos en la ficha del vendedor para datos de los representantes a contactos
      JAV 29/10/20: - QB 1.07.02 Se eliminan las funciones que no se usan del Filter Level, y se mejora el filtrado de proyectos en las OnOpenPageEvent de sales y purchases
      HAN 09/03/21: - Q12932 Assign Vendor No. in FillContractData function
      QMD 09/06/21: - Q13614 Nueva acci�n ItemInvoiceLinesQB en page 137
      JAV 28/06/21: - QB 1.09.03 Ya no se usa el campo "Jobs Budget Code" en su lugar se llama a FunctionQB.ReturnBudgetJobs o a FunctionQB.ReturnBudgetQuote. Se elimnan las funciones
                                 OnAfterGetRecordEvent_Operative Jobs List, OnAfterGetRecordEvent_Operative Jobs Card, AdjustJobBudget
      DGG 28/12/21: - QPR15703 Reparto de importes por periodos
      CPA 24/01/22: - Q16189. En Funci�n SeeSchedulePieceworks: Se blanquea el campo "Entry No." en la tabla para que la llamada a SetData genere un nuevo N� de Movimiento
      JAV 22/02/22: - QB 1.10.21 Se a�aden los nuevos tipos de proyecto al abrir la p�gina est�ndar de Job Card

      CPA 31/03/22: - Q16730 Agregar una columna con el nombre del proveedor en las pantallas de aprobaciones
                      Nueva funci�n: DeleteOrphanApprovalResquests
                      Nuevo event Subscriber: PageApprovalRequestsOnOpenPage
      JAV 10/04/22: - QB 1.10.34 Se eliminan las funciones que no se usan SetMultipleJUCostsJob, SetMultiJobUnits y CopyDefaultDimToDefaultDim
      JAV 20/04/22: - QB 1.10.36 Se pasa la funci�n PageApprovalRequestsOnOpenPage a la CU de Aprobaciones 7207354
      //-QPR15703
      JAV 27/05/22: - QB 1.10.45 Solo se verifica el proyecto si el pedido es contra proyecto
      JAV 06/07/22: - QB 1.10.59 Se pasan las funciones PG1351_OnBeforeChangeDocument, PG10765_OnBeforeChangeDocument, PG10766_OnBeforeChangeDocument, PG10767_OnBeforeChangeDocument desde la CU de Codeunits
      JAV 11/07/22: - QB 1.11.00 Se cambia a RunModal para que no salga el bot�n de programaci�n
      JAV 12/07/22: - QB 1.11.00 Se pasan campos del QuoSII a su CU
      AML 18/07/23: - Q19564 Calculo de la nueva fecha en temporal
      AML 25/09/23: - Q20081 Ajuste para que no proponga m�s unidades de las necesarias en Proforma
    }
END.*/
}








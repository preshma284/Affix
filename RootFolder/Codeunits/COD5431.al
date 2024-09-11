Codeunit 50016 "Calc. Item Plan - Plan Wksh. 1"
{


    TableNo = 27;
    trigger OnRun()
    BEGIN
        Item.COPY(Rec);
        Code;
        Rec := Item;
    END;

    VAR
        Item: Record 27;
        MfgSetup: Record 99000765;
        TempPlanningCompList: Record 99000829 TEMPORARY;
        TempItemList: Record 27 TEMPORARY;
        InvtProfileOffsetting: Codeunit 99000854;
        MPS: Boolean;
        MRP: Boolean;
        NetChange: Boolean;
        PeriodLength: Integer;
        CurrTemplateName: Code[10];
        CurrWorksheetName: Code[10];
        UseForecast: Code[10];
        FromDate: Date;
        ToDate: Date;
        Text000: TextConst ENU = 'You must decide what to calculate.', ESP = 'Debe decidir qu� calcular.';
        Text001: TextConst ENU = 'Enter a starting date.', ESP = 'Especifique una fecha inicial.';
        Text002: TextConst ENU = 'Enter an ending date.', ESP = 'Especifique una fecha final.';
        Text003: TextConst ENU = 'The ending date must not be before the order date.', ESP = 'Fecha final no puede ser anterior a Fecha pedido.';
        Text004: TextConst ENU = 'You must not use a variant filter when calculating MPS from a forecast.', ESP = 'No debe utilizar un filtro variante cuando calcule MPS desde una previsi�n.';
        ExcludeForecastBefore: Date;
        RespectPlanningParm: Boolean;
        QBCodeunitPublisher: Codeunit 7207352;
        ExistsPurchJnLine: Boolean;

    LOCAL PROCEDURE Code();
    VAR
        ReqLineExtern: Record 246;
        PlannedProdOrderLine: Record 5406;
        PlanningAssignment: Record 99000850;
        ProdOrder: Record 5405;
        CurrWorksheetType: Option "Requisition","Planning";
    BEGIN
        WITH Item DO BEGIN
            IF NOT PlanThisItem THEN
                EXIT;

            ReqLineExtern.SETCURRENTKEY(Type, "No.", "Variant Code", "Location Code");
            COPYFILTER("Variant Filter", ReqLineExtern."Variant Code");
            COPYFILTER("Location Filter", ReqLineExtern."Location Code");
            ReqLineExtern.SETRANGE(Type, ReqLineExtern.Type::Item);
            ReqLineExtern.SETRANGE("No.", "No.");
            IF ReqLineExtern.FIND('-') THEN
                REPEAT
                    ReqLineExtern.DELETE(TRUE);
                UNTIL ReqLineExtern.NEXT = 0;

            PlannedProdOrderLine.SETCURRENTKEY(Status, "Item No.", "Variant Code", "Location Code");
            PlannedProdOrderLine.SETRANGE(Status, PlannedProdOrderLine.Status::Planned);
            COPYFILTER("Variant Filter", PlannedProdOrderLine."Variant Code");
            COPYFILTER("Location Filter", PlannedProdOrderLine."Location Code");
            PlannedProdOrderLine.SETRANGE("Item No.", "No.");
            IF PlannedProdOrderLine.FIND('-') THEN
                REPEAT
                    IF ProdOrder.GET(PlannedProdOrderLine.Status, PlannedProdOrderLine."Prod. Order No.") THEN BEGIN
                        IF (ProdOrder."Source Type" = ProdOrder."Source Type"::Item) AND
                           (ProdOrder."Source No." = PlannedProdOrderLine."Item No.")
                        THEN
                            ProdOrder.DELETE(TRUE);
                    END ELSE
                        PlannedProdOrderLine.DELETE(TRUE);
                UNTIL PlannedProdOrderLine.NEXT = 0;

            COMMIT;

            InvtProfileOffsetting.SetParm(UseForecast, ExcludeForecastBefore, CurrWorksheetType::Planning);
            InvtProfileOffsetting.CalculatePlanFromWorksheet(
              Item, MfgSetup, CurrTemplateName, CurrWorksheetName, FromDate, ToDate, MRP, RespectPlanningParm);

            // Retrieve list of Planning Components handled:
            InvtProfileOffsetting.GetPlanningCompList(TempPlanningCompList);

            COPYFILTER("Variant Filter", PlanningAssignment."Variant Code");
            COPYFILTER("Location Filter", PlanningAssignment."Location Code");
            PlanningAssignment.SETRANGE(PlanningAssignment.Inactive, FALSE);
            PlanningAssignment.SETRANGE(PlanningAssignment."Net Change Planning", TRUE);
            PlanningAssignment.SETRANGE(PlanningAssignment."Item No.", "No.");
            IF PlanningAssignment.FIND('-') THEN
                REPEAT
                    IF PlanningAssignment."Latest Date" <= ToDate THEN BEGIN
                        PlanningAssignment.Inactive := TRUE;
                        PlanningAssignment.MODIFY;
                    END;
                UNTIL PlanningAssignment.NEXT = 0;

            COMMIT;

            TempItemList := Item;
            TempItemList.INSERT;
        END;
    END;


    LOCAL PROCEDURE CheckPreconditions();
    VAR
        ForecastEntry: Record 99000852;
    BEGIN
        IF NOT MPS AND NOT MRP THEN
            ERROR(Text000);

        IF FromDate = 0D THEN
            ERROR(Text001);
        IF ToDate = 0D THEN
            ERROR(Text002);
        PeriodLength := ToDate - FromDate + 1;
        IF PeriodLength <= 0 THEN
            ERROR(Text003);

        IF MPS AND
           (Item.GETFILTER("Variant Filter") <> '') AND
           (UseForecast <> '')
        THEN BEGIN
            ForecastEntry.SETCURRENTKEY(ForecastEntry."Production Forecast Name", ForecastEntry."Item No.", ForecastEntry."Location Code", ForecastEntry."Forecast Date", ForecastEntry."Component Forecast");
            ForecastEntry.SETRANGE(ForecastEntry."Production Forecast Name", UseForecast);
            Item.COPYFILTER("No.", ForecastEntry."Item No.");
            IF MfgSetup."Use Forecast on Locations" THEN
                Item.COPYFILTER("Location Filter", ForecastEntry."Location Code");
            IF NOT ForecastEntry.ISEMPTY THEN
                ERROR(Text004);
        END;
    END;

    LOCAL PROCEDURE PlanThisItem(): Boolean;
    VAR
        SKU: Record 5700;
        ForecastEntry: Record 99000852;
        SalesLine: Record 37;
        ServLine: Record 5902;
        PurchaseLine: Record 39;
        ProdOrderLine: Record 5406;
        PlanningAssignment: Record 99000850;
        JobPlanningLine: Record 1003;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforePlanThisItem(Item, IsHandled);
        IF IsHandled THEN
            EXIT;

        SKU.SETCURRENTKEY("Item No.");
        Item.COPYFILTER("Variant Filter", SKU."Variant Code");
        Item.COPYFILTER("Location Filter", SKU."Location Code");
        SKU.SETRANGE("Item No.", Item."No.");
        IF SKU.ISEMPTY AND (Item."Reordering Policy" = Item."Reordering Policy"::" ") THEN
            EXIT(FALSE);

        Item.COPYFILTER("Variant Filter", PlanningAssignment."Variant Code");
        Item.COPYFILTER("Location Filter", PlanningAssignment."Location Code");
        PlanningAssignment.SETRANGE(PlanningAssignment.Inactive, FALSE);
        PlanningAssignment.SETRANGE(PlanningAssignment."Net Change Planning", TRUE);
        PlanningAssignment.SETRANGE(PlanningAssignment."Item No.", Item."No.");
        IF NetChange AND PlanningAssignment.ISEMPTY THEN
            EXIT(FALSE);

        IF MRP = MPS THEN
            EXIT(TRUE);

        SalesLine.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SalesLine.SETFILTER("Document Type", '%1|%2', SalesLine."Document Type"::Order, SalesLine."Document Type"::"Blanket Order");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        Item.COPYFILTER("Variant Filter", SalesLine."Variant Code");
        Item.COPYFILTER("Location Filter", SalesLine."Location Code");
        SalesLine.SETRANGE("No.", Item."No.");
        SalesLine.SETFILTER("Outstanding Qty. (Base)", '<>0');
        IF NOT SalesLine.ISEMPTY THEN
            EXIT(MPS);

        ForecastEntry.SETCURRENTKEY(ForecastEntry."Production Forecast Name", ForecastEntry."Item No.", ForecastEntry."Location Code", ForecastEntry."Forecast Date", ForecastEntry."Component Forecast");
        ForecastEntry.SETRANGE(ForecastEntry."Production Forecast Name", UseForecast);
        IF MfgSetup."Use Forecast on Locations" THEN
            Item.COPYFILTER("Location Filter", ForecastEntry."Location Code");
        ForecastEntry.SETRANGE(ForecastEntry."Item No.", Item."No.");
        IF ForecastEntry.FINDFIRST THEN BEGIN
            ForecastEntry.CALCSUMS(ForecastEntry."Forecast Quantity (Base)");
            IF ForecastEntry."Forecast Quantity (Base)" > 0 THEN
                EXIT(MPS);
        END;

        IF ServLine.LinesWithItemToPlanExist(Item) THEN
            EXIT(MPS);

        IF JobPlanningLine.LinesWithItemToPlanExist(Item) THEN
            EXIT(MPS);

        ProdOrderLine.SETCURRENTKEY("Item No.");
        ProdOrderLine.SETRANGE("MPS Order", TRUE);
        ProdOrderLine.SETRANGE("Item No.", Item."No.");
        IF NOT ProdOrderLine.ISEMPTY THEN
            EXIT(MPS);

        QBCodeunitPublisher.ExistsPurchaseJournalLineCUCalcItemPlanWksh(Item, ExistsPurchJnLine);
        IF ExistsPurchJnLine = TRUE THEN //QB
            EXIT(MPS); //QB

        PurchaseLine.SETCURRENTKEY("Document Type", Type, "No.");
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("MPS Order", TRUE);
        PurchaseLine.SETRANGE("No.", Item."No.");
        IF NOT PurchaseLine.ISEMPTY THEN
            EXIT(MPS);

        EXIT(MRP);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePlanThisItem(Item: Record 27; VAR IsHandled: Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}










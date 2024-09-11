page 7207353 "Purchase Journal Line"
{
    CaptionML = ENU = 'Purchase Journal Line', ESP = 'L�n. Diario Necesidad Compra';
    SaveValues = true;
    InsertAllowed = false;
    SourceTable = 7207281;
    DelayedInsert = true;
    DataCaptionFields = "Job No.";
    PageType = Worksheet;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            field("CurrentJnlBatchName"; CurrentJnlBatchName)
            {

                Lookup = true;
                CaptionML = ENU = 'Batch Name', ESP = 'Nombre secci�n';

                ; trigger OnValidate()
                BEGIN
                    PurchaseJournalManagement.CheckName(CurrentJnlBatchName);
                    CurrentJnlBatchNameOnAfterVali;
                END;

                trigger OnLookup(var Text: Text): Boolean
                BEGIN
                    CurrPage.SAVERECORD;
                    PurchaseJournalManagement.SearchName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                END;


            }
            repeater("Group")
            {

                field("Generate"; rec."Generate")
                {

                }
                field("Date Update"; rec."Date Update")
                {

                }
                field("Date Needed"; rec."Date Needed")
                {

                }
                field("Purchase Deadline Date"; rec."Purchase Deadline Date")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Type"; rec."Type")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {

                }
                field("Job Unit"; rec."Job Unit")
                {

                }
                field("Decription"; rec."Decription")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Activity Code"; rec."Activity Code")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Quantity in Comparatives"; rec."Quantity in Comparatives")
                {

                    BlankZero = true;
                }
                field("Quantity in Contracts"; rec."Quantity in Contracts")
                {

                    BlankZero = true;
                }
                field("Stock Location (Base)"; rec."Stock Location (Base)")
                {

                }
                field("Stock Contracts Items (Base)"; rec."Stock Contracts Items (Base)")
                {

                }
                field("Stock Contracts Resource (B)"; rec."Stock Contracts Resource (B)")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                    Visible = useCurrencies;
                }
                field("Currency Date"; rec."Currency Date")
                {

                    Visible = useCurrencies;
                }
                field("Currency Factor"; rec."Currency Factor")
                {

                    Visible = FALSE;
                }
                field("Direct Unit Cost"; rec."Direct Unit Cost")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Estimated Price"; rec."Estimated Price")
                {

                    Visible = FALSE;
                }
                field("Estimated Amount"; rec."Estimated Amount")
                {

                    Visible = FALSE;
                }
                field("Direct Unit Cost (JC)"; rec."Direct Unit Cost (JC)")
                {

                    Visible = useCurrencies;
                }
                field("Amount (JC)"; rec."Amount (JC)")
                {

                    Visible = useCurrencies;
                }
                field("Target Price"; rec."Target Price")
                {

                }
                field("Target Amount"; rec."Target Amount")
                {

                }
                field("Target Price (JC)"; rec."Target Price (JC)")
                {

                    Visible = useCurrencies;
                }
                field("Target Amount (JC)"; rec."Target Amount (JC)")
                {

                    Visible = useCurrencies;
                }
                field("Vendor No."; rec."Vendor No.")
                {

                }
                field("Vendor Name"; rec."Vendor Name")
                {

                }
                field("Vendor Item No."; rec."Vendor Item No.")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }
            group("group58")
            {

                group("group59")
                {

                    group("group60")
                    {

                        CaptionML = ESP = 'Descripci�n proyecto';
                        field("JobDescription"; JobDescription)
                        {

                            Editable = FALSE;
                            Style = Strong;
                            StyleExpr = TRUE

  ;
                        }

                    }

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Needs', ESP = 'Necesidades';
                action("Calcular")
                {

                    CaptionML = ENU = '&Calculate plan', ESP = 'Calcular plan';
                    Image = Calculate;

                    trigger OnAction()
                    VAR
                        Job: Record 167;
                        Reducir: Option;
                        Eliminar: Boolean;
                        Secciones: Boolean;
                        Procesado: Boolean;
                    BEGIN
                        //vamos a llamar al report que ejecuta esta acci�n y le pasamos el diario
                        Job.SETRANGE("No.", CJob);

                        // CLEAR(CreatePurchaseJournal);
                        // CreatePurchaseJournal.SetParameters(CJob, CurrentJnlBatchName);
                        // CreatePurchaseJournal.SETTABLEVIEW(Job);
                        // CreatePurchaseJournal.RUNMODAL;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = '&Set target prices', ESP = 'Fijar precios objetivos';
                    Image = SalesPrices;

                    trigger OnAction()
                    VAR
                        PurchaseJournalLine: Record 7207281;
                    BEGIN
                        // CLEAR(SetTargetPrices);
                        PurchaseJournalLine.RESET;
                        PurchaseJournalLine.COPYFILTERS(Rec);
                        Rec.FILTERGROUP(2);
                        PurchaseJournalLine.SETRANGE("Job No.", rec.GETFILTER("Job No."));
                        Rec.FILTERGROUP(0);
                        // SetTargetPrices.SETTABLEVIEW(PurchaseJournalLine);
                        // SetTargetPrices.RUNMODAL;
                    END;


                }
                action("Generar")
                {

                    CaptionML = ENU = '&Generate comparative', ESP = 'Generar comparativo';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        PurchaseJournalLine: Record 7207281;
                    BEGIN
                        //vamos a llamar al report que ejecuta esta acci�n mostrando los filtros del diario
                        PurchaseJournalLine.RESET;
                        PurchaseJournalLine.COPYFILTERS(Rec);
                        IF (Rec.HASFILTER AND (Rec.GETFILTER("Job No.") <> '')) THEN BEGIN
                            Rec.FILTERGROUP(2);
                            PurchaseJournalLine.SETRANGE("Job No.", rec.GETFILTER("Job No."));
                            Rec.FILTERGROUP(0);
                        END;
                        // CLEAR(GenerateComparativeResources);
                        // GenerateComparativeResources.SETTABLEVIEW(PurchaseJournalLine);
                        // GenerateComparativeResources.RUNMODAL;
                    END;


                }
                action("<Action1100251006>")
                {

                    CaptionML = ENU = 'C&omparative', ESP = 'C&omparativos';
                    RunObject = Page 7207548;
                    RunPageLink = "Job No." = FIELD("Job No.");
                    Image = BOMVersions;
                }
                action("action5")
                {
                    CaptionML = ENU = 'Generate Purchase Order', ESP = 'Generar pedido de co&mpra';
                    Visible = FALSE;
                    Image = CreateJobSalesInvoice;

                    trigger OnAction()
                    VAR
                        PurchaseJournalLine: Record 7207281;
                    BEGIN
                        //vamos a llamar al report que ejecuta esta acci�n mostrando los filtros del diario
                        // CLEAR(GeneratePurchaseOrder);
                        PurchaseJournalLine.RESET;
                        PurchaseJournalLine.COPYFILTERS(Rec);
                        IF (rec.HASFILTER AND (Rec.GETFILTER("Job No.") <> '')) THEN BEGIN
                            Rec.FILTERGROUP(2);
                            PurchaseJournalLine.SETRANGE("Job No.", rec.GETFILTER("Job No."));
                            Rec.FILTERGROUP(0);
                        END;
                        // GeneratePurchaseOrder.SETTABLEVIEW(PurchaseJournalLine);
                        // GeneratePurchaseOrder.RUNMODAL;
                    END;


                }
                action("PointOfUse")
                {

                    CaptionML = ENU = 'Points Of Use', ESP = 'Puntos de Uso';
                    Image = SplitChecks;

                    trigger OnAction()
                    BEGIN
                        ShowBillOfItemsUse;
                    END;


                }
                action("TextoExtendido")
                {

                    CaptionML = ESP = 'Textos Extendidos';
                    RunObject = Page 7206929;
                    RunPageView = SORTING("Table", "Key1", "Key2", "Key3");
                    //to be refactored
                    RunPageLink = "Table" = CONST("Diario"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Journal Batch Name"); //,"Key3" = FIELD("Line No.");
                    Image = Text;
                }

            }
            group("group10")
            {
                CaptionML = ENU = 'Needs', ESP = 'Asociar';
                action("SetActivity")
                {

                    CaptionML = ENU = 'Activities', ESP = 'Actividad';
                    Image = ServiceItemWorksheet;

                    trigger OnAction()
                    VAR
                        PurchaseJournalLine: Record 7207281;
                        ActivityQB: Record 7207280;
                        QuobuldingActivityList: Page 7207312;
                    BEGIN
                        ActivityQB.RESET;
                        CLEAR(QuobuldingActivityList);
                        QuobuldingActivityList.SETTABLEVIEW(ActivityQB);
                        QuobuldingActivityList.LOOKUPMODE(TRUE);
                        IF (QuobuldingActivityList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                            QuobuldingActivityList.GETRECORD(ActivityQB);

                            PurchaseJournalLine := Rec;
                            CurrPage.SETSELECTIONFILTER(PurchaseJournalLine);
                            IF PurchaseJournalLine.FINDSET THEN
                                REPEAT
                                    PurchaseJournalLine."Activity Code" := ActivityQB."Activity Code";
                                    PurchaseJournalLine.MODIFY;
                                UNTIL PurchaseJournalLine.NEXT = 0;
                        END;
                    END;


                }
                action("SetVendor")
                {

                    CaptionML = ENU = 'Find by Vendor', ESP = 'Proveedor';
                    Image = SubcontractingWorksheet;

                    trigger OnAction()
                    VAR
                        PurchaseJournalLine: Record 7207281;
                        VendorQualityData: Record 7207418;
                        VendorQltyDataList: Page 7207339;
                    BEGIN
                        PurchaseJournalLine := Rec;
                        CurrPage.SETSELECTIONFILTER(PurchaseJournalLine);

                        VendorQualityData.RESET;
                        IF (rec."Vendor No." <> '') THEN
                            VendorQualityData.SETRANGE("Vendor No.", rec."Vendor No.");

                        CLEAR(VendorQltyDataList);
                        VendorQltyDataList.SETTABLEVIEW(VendorQualityData);
                        VendorQltyDataList.LOOKUPMODE(TRUE);
                        IF (VendorQltyDataList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                            VendorQltyDataList.GETRECORD(VendorQualityData);

                            PurchaseJournalLine := Rec;
                            CurrPage.SETSELECTIONFILTER(PurchaseJournalLine);
                            IF PurchaseJournalLine.FINDSET THEN
                                REPEAT
                                    PurchaseJournalLine."Vendor No." := VendorQualityData."Vendor No.";
                                    PurchaseJournalLine."Activity Code" := VendorQualityData."Activity Code";
                                    PurchaseJournalLine.MODIFY;
                                UNTIL PurchaseJournalLine.NEXT = 0;
                        END;
                    END;


                }

            }
            group("group13")
            {
                CaptionML = ENU = '&Reports', ESP = 'Informes';
                action("action10")
                {
                    CaptionML = ENU = 'TreeMAp', ESP = 'TreeMap';
                    //Missing in QUO db
                    // RunObject = Page 7000659;
                    Visible = FALSE;
                    Image = Zones;
                }
                action("action11")
                {
                    CaptionML = ENU = '&Purchase plan of the Job', ESP = 'Plan de compras de la obra';
                    // RunObject = Report 7207360;
                    Image = PrintReport;
                }
                action("action12")
                {
                    CaptionML = ENU = '&Needs of the Job', ESP = 'Necesidades de la Obra';
                    // RunObject = Report 7207359;
                    Image = PrintAcknowledgement;
                }
                action("<Action1100251002>")
                {

                    CaptionML = ENU = '&Needs per level', ESP = 'Necesidades por nivel';
                    // RunObject = Report 7207372;
                    Image = PrintExcise;
                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Proceso';

                actionref(Calcular_Promoted; Calcular)
                {
                }
                actionref("<Action1100251006>_Promoted"; "<Action1100251006>")
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(PointOfUse_Promoted; PointOfUse)
                {
                }
                actionref(TextoExtendido_Promoted; TextoExtendido)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(Generar_Promoted; Generar)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(action10_Promoted; action10)
                {
                }
                actionref(action11_Promoted; action11)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref("<Action1100251002>_Promoted"; "<Action1100251002>")
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Associate', ESP = 'Asociar';

                actionref(SetActivity_Promoted; SetActivity)
                {
                }
                actionref(SetVendor_Promoted; SetVendor)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        JobNoEdit := TRUE;

        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnOpenPage()
    BEGIN
        IF (rec."Journal Batch Name" <> '') THEN
            CurrentJnlBatchName := rec."Journal Batch Name";

        PurchaseJournalManagement.OpenJournalName(CurrentJnlBatchName, Rec);

        Rec.FILTERGROUP(2);
        Rec.SETFILTER("Job No.", CJob);
        JobNoEdit := FALSE;
        Rec.FILTERGROUP(0);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
        Rec.CALCFIELDS("Vendor Name");
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.SetUpNewLine(xRec);
        CLEAR(ShortcutDimCode);
    END;



    var
        JobPlanningLine: Record 1003;
        // CreatePurchaseJournal: Report 7207342;
        // SetTargetPrices: Report 7207343;
        // GenerateComparativeResources: Report 7207344;
        // GeneratePurchaseOrder: Report 7207324;
        PurchaseJournalManagement: Codeunit 7207286;
        FunctionQB: Codeunit 7207272;
        CJob: Code[20];
        CurrentJnlBatchName: Code[20];
        ShortcutDimCode: ARRAY[8] OF Code[20];
        JobDescription: Text[60];
        JobNoEdit: Boolean;
        OpenedFromBatch: Boolean;
        JnlSelected: Boolean;
        useCurrencies: Boolean;
        Err001: TextConst ENU = 'You cannot select more than one line', ESP = 'No se puede seleccionar mas de una l�nea';
        JobCurrencyExchangeFunction: Codeunit 7207332;

    LOCAL procedure CurrentJnlBatchNameOnAfterVali();
    begin
        CurrPage.SAVERECORD;
        PurchaseJournalManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    procedure PassJob(PJob: Code[20]);
    begin
        CJob := PJob;
    end;

    procedure ShowBillOfItemsUse();
    var
        BillOfItemsUses: Page 7207580;
        DataCostByJU: Record 7207387;
        PurchaseJournalLine: Record 7207281;
        Job: Record 167;
    begin
        //JAV a partir de COMGAP011 de Arpada
        CurrPage.SETSELECTIONFILTER(PurchaseJournalLine);
        if PurchaseJournalLine.COUNT > 1 then
            ERROR(Err001);

        PurchaseJournalLine.FINDFIRST;
        Job.GET(PurchaseJournalLine."Job No.");

        DataCostByJU.RESET;
        DataCostByJU.SETRANGE("Job No.", PurchaseJournalLine."Job No.");
        DataCostByJU.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
        if PurchaseJournalLine.Type = PurchaseJournalLine.Type::Item then
            DataCostByJU.SETRANGE("Cost Type", DataCostByJU."Cost Type"::Item);
        if PurchaseJournalLine.Type = PurchaseJournalLine.Type::Resource then
            DataCostByJU.SETRANGE("Cost Type", DataCostByJU."Cost Type"::Resource);
        DataCostByJU.SETRANGE("No.", PurchaseJournalLine."No.");

        CLEAR(BillOfItemsUses);
        BillOfItemsUses.SETTABLEVIEW(DataCostByJU);
        BillOfItemsUses.RUNMODAL;
    end;

    LOCAL procedure DeleteInQuotes(pReducir: Option);
    var
        ComparativeQuoteHeader: Record 7207412;
        ComparativeQuoteLines: Record 7207413;
        PurchaseJournalLine: Record 7207281;
        CtComp: Decimal;
        CtCont: Decimal;
        Cantidad: Decimal;
        CantidadEliminada: Decimal;
    begin
        //JAV 09/08/19: - Eliminamos las cantidades que est�n en comparativos generados para el proyecto
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Job No.", CJob);
        if (ComparativeQuoteLines.FINDSET(FALSE)) then
            repeat
                //JAV 30/10/19: - Se guarda la cantidad en comprativos y en contratos
                ComparativeQuoteHeader.GET(ComparativeQuoteLines."Quote No.");

                CtComp := ComparativeQuoteLines.Quantity;
                CtCont := 0;
                if (ComparativeQuoteHeader."Generated Contract Doc No." <> '') then
                    CtCont := ComparativeQuoteLines.Quantity;

                CASE pReducir OF
                    0:
                        Cantidad := CtComp;
                    1:
                        Cantidad := CtCont;
                    2:
                        Cantidad := 0;
                end;

                PurchaseJournalLine.RESET;
                PurchaseJournalLine.SETRANGE("Job No.", ComparativeQuoteLines."Job No.");
                PurchaseJournalLine.SETRANGE(Type, ComparativeQuoteLines.Type);
                PurchaseJournalLine.SETRANGE("No.", ComparativeQuoteLines."No.");
                //JMMA 14/10/19: - Se a�ade un filtro que faltaba en el proceso de ajuste de cantidades y no se elimina la l�nea sino que se deja a cero
                PurchaseJournalLine.SETRANGE("Job Unit", ComparativeQuoteLines."Piecework No.");
                if (PurchaseJournalLine.FINDSET(TRUE)) then
                    repeat
                        //JAV 30/10/19: - Se guarda la cantidad en comprativos y en contratos
                        PurchaseJournalLine."Quantity in Comparatives" += CtComp;
                        PurchaseJournalLine."Quantity in Contracts" += CtCont;
                        if (Cantidad > 0) then begin
                            if Cantidad >= PurchaseJournalLine.Quantity then begin
                                CantidadEliminada := PurchaseJournalLine.Quantity;
                                PurchaseJournalLine.Quantity := 0;            //JMMA 14/10/19: - No se elimina la l�nea, se deja a cero
                            end ELSE begin
                                CantidadEliminada := Cantidad;
                                PurchaseJournalLine.Quantity -= Cantidad;
                            end;
                            Cantidad -= CantidadEliminada;
                        end;
                        PurchaseJournalLine.MODIFY;
                    until (PurchaseJournalLine.NEXT = 0);
            until (ComparativeQuoteLines.NEXT = 0);
    end;

    LOCAL procedure DeleteInSections();
    var
        PurchaseJournalLine1: Record 7207281;
        PurchaseJournalLine2: Record 7207281;
        CtComp: Decimal;
        CtCont: Decimal;
        Cantidad: Decimal;
        CantidadEliminada: Decimal;
    begin
        //JAV 09/08/19: - Eliminamos las cantidades que est�n en otras secciones
        PurchaseJournalLine1.RESET;
        PurchaseJournalLine1.SETRANGE("Job No.", CJob);
        PurchaseJournalLine1.SETFILTER("Journal Batch Name", '<>%1', CurrentJnlBatchName);
        if (PurchaseJournalLine1.FINDSET(FALSE)) then
            repeat
                Cantidad := PurchaseJournalLine1.Quantity;

                PurchaseJournalLine2.RESET;
                PurchaseJournalLine2.SETRANGE("Job No.", PurchaseJournalLine1."Job No.");
                PurchaseJournalLine2.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
                PurchaseJournalLine2.SETRANGE(Type, PurchaseJournalLine1.Type);
                PurchaseJournalLine2.SETRANGE("No.", PurchaseJournalLine1."No.");
                PurchaseJournalLine2.SETRANGE("Job Unit", PurchaseJournalLine1."Job Unit");
                if (PurchaseJournalLine2.FINDSET(TRUE)) then
                    repeat
                        if (Cantidad > 0) then begin
                            if Cantidad >= PurchaseJournalLine2.Quantity then begin
                                CantidadEliminada := PurchaseJournalLine2.Quantity;
                                PurchaseJournalLine2.Quantity := 0;             //JMMA 14/10/19: - No se elimina la l�nea, se deja a cero
                            end ELSE begin
                                CantidadEliminada := Cantidad;
                                PurchaseJournalLine2.Quantity -= Cantidad;
                            end;
                            Cantidad -= CantidadEliminada;
                        end;
                        PurchaseJournalLine2.MODIFY;
                    until (PurchaseJournalLine2.NEXT = 0);
            until (PurchaseJournalLine1.NEXT = 0);
    end;

    LOCAL procedure DeleteZeros();
    var
        PurchaseJournalLine1: Record 7207281;
        PurchaseJournalLine2: Record 7207281;
        CtComp: Decimal;
        CtCont: Decimal;
        Cantidad: Decimal;
    begin
        //JAV 30/10/19: - Nuevo par�metro sobre eliminar o no las l�neas a cero
        PurchaseJournalLine2.RESET;
        PurchaseJournalLine2.SETRANGE("Job No.", CJob);
        PurchaseJournalLine2.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        PurchaseJournalLine2.SETRANGE(Quantity, 0);
        PurchaseJournalLine2.DELETEALL(TRUE);
    end;

    // begin
    /*{
      JAV  29/05/19: - Se a�ade la columna de precio objetivo
      JAV  09/08/19: - Eliminamos las l�neas que est�n en comparativos generados
      JMMA 14/10/19: - Se a�ade un filtro que faltaba en el proceso de ajuste de cantidades y no se elimina la l�nea sino que se deja a cero
      JDC  24/07/19: - GAP020 Added field 50000 rec."Vendor Name"
      JAV  30/10/19: - Si no se usan las divisas en el proyecto, no presentar los campos
                     - Se a�aden las columnas de cantidad en comprativos y en contratos
    }*///end
}








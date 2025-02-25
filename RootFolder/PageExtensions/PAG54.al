pageextension 50226 MyExtension54 extends 54//39
{
    layout
    {
        addfirst("Control1")
        {
            field("HaveExtendedText()"; HaveExtendedText())
            {

                CaptionML = ESP = 'Texto Extendido';
            }
            // field("Job No."; rec."Job No.")
            // {

            //     ToolTipML = ENU = 'Specif( ies the number of the related job. If you fill in this field and the Job Task No. field,  )then a job ledger entry will be posted together with the purchase line.', ESP = 'Especifica el n£mero del proyecto relacionado. Si rellena este campo y el campo N.§ tarea proyecto, se registrar  un movimiento de proyecto junto con la l¡nea de compra.';
            //     ApplicationArea = Jobs;

            //     ; trigger OnValidate()
            //     BEGIN
            //         rec.ShowShortcutDimCode(ShortcutDimCode);
            //     END;


            // }
            field("QB_JobDescription"; "JobDescription")
            {

                CaptionML = ENU = 'Job Description', ESP = 'Descripci¢n del Proyecto';
                Visible = false;
                Editable = false;
            }
            field("QB_PieceworkNo"; rec."Piecework No.")
            {

                CaptionClass = txtPiecework;
            }
            field("QB_CodePieceworkPRESTO"; rec."Code Piecework PRESTO")
            {

                Visible = FALSE;
            }
            field("QB CA Value"; rec."QB CA Value")
            {

                ToolTipML = ESP = 'Contiene el Concepto anal¡tico que se va a asociar a la l¡nea. Se utiliza en lugar de la dimensi¢n para independizarnos de su n£mero';
            }
        }
        addafter("Bin Code")
        {
            field("QB_External Worksheet Lines"; rec."External Worksheet Lines")
            {

                BlankZero = true;
                Visible = seeExternalWorkseet;
                Style = Attention;
                StyleExpr = TRUE;

                ; trigger OnAssistEdit()
                BEGIN
                    ApplyExternalWorksheet;
                END;


            }
            field("QB_External Worksheet Aplied"; rec."External Worksheet Aplied")
            {

                BlankZero = true;
                Visible = seeExternalWorkseet;
                Style = Favorable;
                StyleExpr = TRUE;

                ; trigger OnAssistEdit()
                BEGIN
                    ApplyExternalWorksheet;
                END;


            }
            field("QB Contract Qty. Original"; rec."QB Contract Qty. Original")
            {

                BlankZero = true;
            }
            field("QB Framework Contr. No."; rec."QB Framework Contr. No.")
            {

            }
        }
        addafter("Quantity")
        {
            field("QB_Splitted_Line"; rec."QB Splitted Line Date")
            {

                Editable = FALSE;
            }
            field("QB_Base_Splitted_Line"; rec."QB Splitted Line Base" <> 0)
    {

                CaptionML = ENU = 'Division', ESP = 'Divisi¢n';
                Editable = FALSE;
            }
        }
        addafter("Line Amount")
        {
            field("QW Not apply Withholding GE"; rec."QW Not apply Withholding GE")
            {


                ; trigger OnValidate()
                BEGIN
                    //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l­nea
                    QB_UpdateLineTotals;
                END;


            }
            field("QW % Withholding by GE"; rec."QW % Withholding by GE")
            {

                Visible = FALSE;
            }
            field("QW Withholding Amount by GE"; rec."QW Withholding Amount by GE")
            {

                Visible = FALSE;
            }
            field("QW Not apply Withholding PIT"; rec."QW Not apply Withholding PIT")
            {


                ; trigger OnValidate()
                BEGIN
                    //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l­nea
                    QB_UpdateLineTotals;
                END;


            }
            field("QW % Withholding by PIT"; rec."QW % Withholding by PIT")
            {

                Visible = FALSE;
            }
            field("QW Withholding Amount by PIT"; rec."QW Withholding Amount by PIT")
            {

                Visible = FALSE;
            }
        }
        addafter("Inv. Discount Amount")
        {
            field("Outstanding Quantity"; rec."Outstanding Quantity")
            {

                Style = StandardAccent;
                StyleExpr = TRUE;
            }
        }
        addafter("Qty. to Receive")
        {
            field("QB_QtyReceiveOrigin"; "QB_QtyReceiveOrigin")
            {

                CaptionML = ESP = 'Cantidad a recibir a Origen';

                ; trigger OnValidate()
                BEGIN
                    //Validar la cantidad a recibir a origen, modificando la cantidad a recibir. Controlar que no sea negativo
                    IF (QB_QtyReceiveOrigin < 0) THEN
                        ERROR('No puede recibir a origen en negativo');
                    //IF (QB_QtyReceiveOrigin < rec."Quantity Received") THEN
                    //  ERROR('No puede recibir menos de los ya recibido');

                    Rec.VALIDATE("Qty. to Receive", QB_QtyReceiveOrigin - rec."Quantity Received");
                    Calc_Proform;
                    CurrPage.UPDATE;  //Refrescar los totales
                END;


            }
            field("QB Line Proformable"; rec."QB Line Proformable")
            {

            }
            field("QB Qty. Proformed"; rec."QB Qty. Proformed")
            {

                BlankZero = true;
            }
            field("QB Qty. To Proform"; rec."QB Qty. To Proform")
            {

                BlankZero = true;

                ; trigger OnValidate()
                BEGIN
                    CurrPage.UPDATE;  //Refrescar los totales
                END;


            }
            field("QB_QtyProformOrigin"; "QB_QtyProformOrigin")
            {

                CaptionML = ESP = 'Cnt. Gen. Proforma a Origen';

                ; trigger OnValidate()
                BEGIN
                    //Validar la cantidad a proformar a origen, modificando la cantidad a proformar. Controlar que no sea negativo
                    IF (QB_QtyProformOrigin < 0) THEN
                        ERROR('No puede recibir a origen en negativo');
                    //IF (QB_QtyReceiveOrigin < rec."Quantity Received") THEN
                    //  ERROR('No puede recibir menos de los ya recibido');

                    Rec.VALIDATE("QB Qty. To Proform", QB_QtyProformOrigin - rec."QB Qty. Proformed");
                    Calc_Proform;
                    CurrPage.UPDATE;  //Refrescar los totales
                END;


            }
        }
        addafter("Line No.")
        {
            field("QB_AmountReceiveOrigin"; "QB_AmountReceiveOrigin")
            {

                CaptionML = ENU = 'Amount to be received at origin', ESP = 'Importe a Recibir a origen';
                Editable = FALSE;
            }
            field("QB_AmountProformOrigin"; "QB_AmountProformOrigin")
            {

                CaptionML = ENU = 'Amount to be proformed at origin', ESP = 'Importe Gen.Proforma a origen';
                Editable = FALSE;
            }
        }
        addafter("Control43")
        {
            group("Control1100286016")
            {

                group("Control1100286007")
                {

                    field("QB_Base"; "QB_Base")
                    {

                        CaptionML = ENU = 'Total Withholding G.E', ESP = 'Base Imponible';
                        Editable = false;
                    }
                    field("QB_IVA"; "QB_IVA")
                    {

                        CaptionML = ENU = 'Total Withholding G.E', ESP = 'IVA';
                        Editable = false;
                    }
                    field("QB_IRPF"; "QB_IRPF")
                    {

                        CaptionML = ENU = 'Total Withholding PIT', ESP = 'IRPF';
                        Editable = false;
                    }
                    field("QB_Total"; "QB_Total")
                    {

                        CaptionML = ENU = 'TOTAL', ESP = 'TOTAL PEDIDO';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("QB_Ret"; "QB_Ret")
                    {

                        CaptionML = ENU = 'Total Withholding G.E', ESP = 'Retenci¢n Pago';
                        Editable = false;
                    }
                    field("QB_Pagar"; "QB_Pagar")
                    {

                        CaptionML = ENU = 'TOTAL', ESP = 'TOTAL A PAGAR';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                }
                group("Control1100286003")
                {

                    field("QB_BaseAlbaran"; "QB_BaseAlbaran")
                    {

                        CaptionML = ESP = 'Base Imponible Recepci¢n';
                        Editable = FALSE;
                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }
                    field("QB_BaseProforma"; "QB_BaseProforma")
                    {

                        CaptionML = ESP = 'Base Imponible Proforma';
                        Editable = FALSE;
                    }
                    field("QB_BaseFactura"; "QB_BaseFactura")
                    {

                        CaptionML = ESP = 'Base Imponible Factura';
                        Editable = FALSE;
                    }
                }
            }
        }


        //modify("Quantity")
        //{
        //
        //
        //}
        //

        //modify("Direct Unit Cost")
        //{
        //
        //
        //}
        //

        //modify("Line Discount %")
        //{
        //
        //
        //}
        //

        modify("Control43")
        {
            Visible = false;


        }


        modify("Control37")
        {
            Visible = false;


        }


        modify("Control19")
        {
            Visible = false;


        }

    }

    actions
    {
        addfirst("Processing")
        {
            action("Action1100286014")
            {
                CaptionML = ESP = 'Textos Extendidos';
                RunObject = Page 7206929;
                RunPageView = SORTING("Table", "Key1", "Key2", "Key3");
                // RunPageLink = "Table" = CONST("Contrato"), "Key1" = field("Document Type"), "Key2" = field("Document No."), "Key3" = field("Line No.");
                Image = Text;
            }
            action("QB_LastProform")
            {
                CaptionML = ESP = 'Ultima Proforma';
                Image = Document;
            }
            action("QB_Split")
            {

                CaptionML = ENU = 'Split', ESP = 'Dividir';
                ToolTipML = ENU = 'Esta acci¢n divide la l¡nea en dos, cambia la cantidad por la recibida hasta el momento en la l¡nea actual y crea una nueva con la cantidad pendiente de recibir';
                Image = Splitlines;

                trigger OnAction()
                BEGIN
                    //JAV 07/11/22: - QB 1.12.13 Proceso para dividir una l¡nea, se crea la acci¢n QB_Split.
                    QBTableSubscriber.T39_SplitLine(Rec, Rec."Direct Unit Cost", Rec."Direct Unit Cost");
                    CurrPage.UPDATE(FALSE);
                END;


            }
            action("InsertAutoLine")
            {
                CaptionML = ESP = 'Insertar L¡nea Autom tica';
                Promoted = true;
                Visible = seeInsertLineAuto;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
        }


        // moveafter("ActionContainer1900000004"; "&Line")

        //modify("SelectMultiItems")
        //{
        //
        //
        //}
        //

        modify("Dimensions")
        {

            trigger OnBeforeAction()
            BEGIN
                Commit; //JAV 30/05/22: QB 1.10.45 Para evitar error de RunModal
            END;

        }

    }

    //trigger

    trigger OnOpenPage()
    var
        ApplicationAreaMgmtFacade: Codeunit 9179;

    begin

        //QB 1.06.10 - JAV 24/08/20: - Ver partes de externos
        seeExternalWorkseet := (FunctionQB.QB_UseExternalWookshet);

        //QRE15449-INI
        QBPurchLineExt.Read(Rec);
        //QRE15449-FIN

        PurchasesPayablesSetup.GET;
        // TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Purchases);
        TempOptionLookupBuffer.FillLookupBuffer(TempOptionLookupBuffer."Lookup Type"::Purchases);
        IsFoundation := ApplicationAreaMgmtFacade.IsFoundationEnabled;
        Currency.InitRoundingPrecision;

        //QB 1.06.10 - JAV 24/08/20: - Ver partes de externos
        seeExternalWorkseet := (FunctionQB.QB_UseExternalWookshet);

    end;

    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
        UpdateTypeText;
        SetItemChargeFieldsStyle;

        //QB
        SetEditable();
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.InitType;
        // Default to Item for the first line and to previous line type for the others
        IF ApplicationAreaMgmtFacade.IsFoundationEnabled THEN
            IF xRec."Document No." = '' THEN
                rec."Type" := rec."Type"::Item;

        CLEAR(ShortcutDimCode);
        UpdateTypeText;

        //JAV 23/05/22: - QB 1.10.42 Al inicializar el registro ponemos los valores de la cabecera y refrescamos las dimensiones, no puede usar el evento OnInit de la page porque se lanza despu‚s de este
        QPRPageSubscriber.PurchaseLine_InitValues(Rec);
        rec.ShowShortcutDimCode(ShortcutDimCode);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        GetTotalsPurchaseHeader;
        CalculateTotals;
        UpdateEditableOnRow;
        UpdateTypeText;
        SetItemChargeFieldsStyle;

        //QB
        SetEditable();
        //Calcular totales del documento
        QB_CalculateDocTotals;
    END;


    //trigger

    var
        TotalPurchaseHeader: Record 38;
        TotalPurchaseLine: Record 39;
        PurchaseHeader: Record 38;
        Currency: Record 4;
        PurchasesPayablesSetup: Record 312;
        TempOptionLookupBuffer: Record 1670 TEMPORARY;
        ApplicationAreaMgmtFacade: Codeunit 9179;
        TransferExtendedText: Codeunit 378;
        ItemAvailFormsMgt: Codeunit 353;
        Text001: TextConst ENU = 'You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.', ESP = 'No puede usar la funci¢n Desplegar L.M. puesto que se ha facturado un prepago del pedido de compra.';
        PurchCalcDiscByType: Codeunit 66;
        DocumentTotals: Codeunit 57;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        AmountWithDiscountAllowed: Decimal;
        TypeAsText: Text[30];
        ItemChargeStyleExpression: Text;
        InvDiscAmountEditable: Boolean;
        IsCommentLine: Boolean;
        IsFoundation: Boolean;
        UpdateInvDiscountQst: TextConst ENU = 'One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?', ESP = 'Se han facturado una o varias l¡neas. No se tendr  en cuenta el descuento distribuido entre las l¡neas facturadas.\\¨Desea actualizar el descuento en factura?';
        CurrPageIsEditable: Boolean;
        "------------------------------ QB": Integer;
        FunctionQB: Codeunit 7207272;
        QPRPageSubscriber: Codeunit 7238190;
        seeExternalWorkseet: Boolean;
        QB_QtyReceiveOrigin: Decimal;
        QB_QtyProformOrigin: Decimal;
        QB_AmountReceiveOrigin: Decimal;
        QB_AmountProformOrigin: Decimal;
        txtPiecework: Text;
        QBTableSubscriber: Codeunit 7207347;
        "------------------------------------ QB Totales": Integer;
        QB_Base: Decimal;
        QB_IVA: Decimal;
        QB_IRPF: Decimal;
        QB_Total: Decimal;
        QB_Ret: Decimal;
        QB_Pagar: Decimal;
        QB_BaseAlbaran: Decimal;
        QB_BaseProforma: Decimal;
        QB_BaseFactura: Decimal;
        "-------------------------------------------QRE": Integer;
        QREFunctions: Codeunit 7238197;
        QBPurchLineExt: Record 7238729;
        seeInsertLineAuto: Boolean;
        JobDescription: Text;
        Job: Record 167;



    //procedure
    //procedure ApproveCalcInvDisc();
    //    begin
    //      CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    //      DocumentTotals.PurchaseDocTotalsNotUpToDate;
    //    end;
    //Local procedure ValidateInvoiceDiscountAmount();
    //    begin
    //      PurchaseHeader.GET(rec."Document Type",rec."Document No.");
    //      if ( PurchaseHeader.InvoicedLineExists  )then
    //        if ( not CONFIRM(UpdateInvDiscountQst,FALSE)  )then
    //          exit;
    //
    //      DocumentTotals.PurchaseDocTotalsNotUpToDate;
    //      PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchaseHeader);
    //      CurrPage.UPDATE(FALSE);
    //    end;
    //Local procedure ExplodeBOM();
    //    begin
    //      if ( rec."Prepmt. Amt. Inv." <> 0  )then
    //        ERROR(Text001);
    //      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    //      DocumentTotals.PurchaseDocTotalsNotUpToDate;
    //    end;
    //Local procedure OpenSalesOrderForm();
    //    var
    //      SalesHeader : Record 36;
    //      SalesOrder : Page 42;
    //    begin
    //      Rec.TESTfield("Sales Order No.");
    //      SalesHeader.SETRANGE("No.",rec."Sales Order No.");
    //      SalesOrder.SETTABLEVIEW(SalesHeader);
    //      SalesOrder.EDITABLE := FALSE;
    //      SalesOrder.RUN;
    //    end;
    //
    //    //[External]
    //procedure InsertExtendedText(Unconditionally : Boolean);
    //    begin
    //      OnBeforeInsertExtendedText(Rec);
    //      if ( TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally)  )then begin
    //        CurrPage.SAVERECORD;
    //        TransferExtendedText.InsertPurchExtText(Rec);
    //      end;
    //      if ( TransferExtendedText.MakeUpdate  )then
    //        UpdateForm(TRUE);
    //    end;
    //
    //    //[External]
    //procedure ShowTracking();
    //    var
    //      TrackingForm : Page 99000822;
    //    begin
    //      TrackingForm.SetPurchLine(Rec);
    //      TrackingForm.RUNMODAL;
    //    end;
    //Local procedure OpenSpecOrderSalesOrderForm();
    //    var
    //      SalesHeader : Record 36;
    //      SalesOrder : Page 42;
    //    begin
    //      Rec.TESTfield("Special Order Sales No.");
    //      SalesHeader.SETRANGE("No.",rec."Special Order Sales No.");
    //      SalesOrder.SETTABLEVIEW(SalesHeader);
    //      SalesOrder.EDITABLE := FALSE;
    //      SalesOrder.RUN;
    //    end;
    //
    //    //[External]
    //procedure UpdateForm(SetSaveRecord : Boolean);
    //    begin
    //      CurrPage.UPDATE(SetSaveRecord);
    //    end;
    //Local procedure NoOnAfterValidate();
    //    begin
    //      UpdateEditableOnRow;
    //      InsertExtendedText(FALSE);
    //      if (rec."Type" = rec."Type"::"Charge (Item)") and (rec."No." <> xRec."No.") and
    //         (xRec."No." <> '')
    //      then
    //        CurrPage.SAVERECORD;
    //    end;
    //Local procedure CrossReferenceNoOnAfterValidat();
    //    begin
    //      InsertExtendedText(FALSE);
    //    end;
    //
    //    //[External]
    procedure ShowDocumentLineTracking();
    var
        DocumentLineTracking: Page 6560;
    begin
        //DGG 07/08/22: QB 1.11.01 (Q17847) Se a¤ade Commit para que no de error
        COMMIT;

        CLEAR(DocumentLineTracking);
        DocumentLineTracking.SetDoc(1, rec."Document No.", rec."Line No.", rec."Blanket Order No.", rec."Blanket Order Line No.", '', 0);
        DocumentLineTracking.RUNMODAL;
    end;
    Local procedure GetTotalsPurchaseHeader();
       begin
         DocumentTotals.GetTotalPurchaseHeaderAndCurrency(Rec,TotalPurchaseHeader,Currency);
       end;
    //Local procedure CalculateTotals();
    //    begin
    //      DocumentTotals.PurchaseCheckIfDocumentChanged(Rec,xRec);
    //      DocumentTotals.CalculatePurchaseSubPageTotals(
    //        TotalPurchaseHeader,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
    //      DocumentTotals.RefreshPurchaseLine(Rec);
    //    end;
    //Local procedure DeltaUpdateTotals();
    //    begin
    //      DocumentTotals.PurchaseDeltaUpdateTotals(Rec,xRec,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
    //      if ( rec."Line Amount" <> xRec."Line Amount"  )then begin
    //        CurrPage.SAVERECORD;
    //        rec.SendLineInvoiceDiscountResetNotification;
    //        CurrPage.UPDATE(FALSE);
    //      end;
    //    end;
    //Local procedure UpdateEditableOnRow();
    //    begin
    //      IsCommentLine := rec."Type" = rec."Type"::" ";
    //      CurrPageIsEditable := CurrPage.EDITABLE;
    //      InvDiscAmountEditable := CurrPageIsEditable and not PurchasesPayablesSetup."Calc. Inv. Discount";
    //    end;
    //Local procedure UpdateTypeText();
    //    var
    //      RecRef : RecordRef;
    //    begin
    //      if ( not IsFoundation  )then
    //        exit;
    //
    //      RecRef.GETTABLE(Rec);
    //      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.field(FIELDNO(rec."Type")));
    //    end;
    Local procedure SetItemChargeFieldsStyle();
       begin
         ItemChargeStyleExpression := '';
         if ( rec.AssignedItemCharge and (rec."Qty. Assigned" <> rec."Quantity")  )then
           ItemChargeStyleExpression := 'Unfavorable';
       end;
    //
    //    [Integration]
    //Local procedure OnBeforeInsertExtendedText(var PurchaseLine : Record 39);
    //    begin
    //    end;
    //
    //    [Integration]
    //Local procedure OnCrossReferenceNoOnLookup(var PurchaseLine : Record 39);
    //    begin
    //    end;
    LOCAL procedure "------------------------------------------ QB"();
    begin
    end;

    procedure Decomposed();
    var
        PurchaseLine: Record 39;
        // GenerateBrokenDownPurchL: Report 7207350;
    begin
        //QB2516
        CurrPage.SETSELECTIONFILTER(PurchaseLine);
        // GenerateBrokenDownPurchL.SETTABLEVIEW(PurchaseLine);
        // GenerateBrokenDownPurchL.USEREQUESTPAGE := FALSE;
        // GenerateBrokenDownPurchL.RUNMODAL;
        // CLEAR(GenerateBrokenDownPurchL);
    end;

    LOCAL procedure HaveExtendedText(): Text[2];
    var
        OptionTointeger: Integer;
        QBText: Record 7206918;
    begin
        OptionTointeger := rec."Document Type".AsInteger();
        exit(FORMAT(QBText.GET(QBText.Table::Contrato, FORMAT(OptionTointeger), rec."Document No.", FORMAT(rec."Line No."))));
    end;

    LOCAL procedure ApplyExternalWorksheet();
    var
        QBExternalWorksheetLinesPo: Record 7206936;
        QBExternalWorksheetLinFac: Page 7206955;
    begin
        QBExternalWorksheetLinesPo.RESET;
        QBExternalWorksheetLinesPo.SETRANGE("Vendor No.", Rec."Buy-from Vendor No.");
        QBExternalWorksheetLinesPo.SETRANGE("Job No.", Rec."Job No.");
        QBExternalWorksheetLinesPo.SETRANGE("Piecework No.", Rec."Piecework No.");
        QBExternalWorksheetLinesPo.SETFILTER("Apply to Document No", '%1|%2', '', rec."Document No.");  //Solo las de este documento o que que no est‚n en otro documento
        if ((QBExternalWorksheetLinesPo.ISEMPTY)) then
            exit;

        CLEAR(QBExternalWorksheetLinFac);
        QBExternalWorksheetLinFac.SETTABLEVIEW(QBExternalWorksheetLinesPo);
        QBExternalWorksheetLinFac.SetDocument(rec."Document Type", rec."Document No.");
        QBExternalWorksheetLinFac.RUNMODAL;
    end;

    LOCAL procedure Calc_Proform();
    begin
        //Q13153 -
        Rec.CALCFIELDS("QB Qty. Proformed");
        QB_QtyReceiveOrigin := rec."Quantity Received" + rec."Qty. to Receive";
        QB_QtyProformOrigin := rec."QB Qty. Proformed" + rec."QB Qty. To Proform";
        QB_AmountReceiveOrigin := QB_QtyReceiveOrigin * rec."Unit Cost";
        QB_AmountProformOrigin := QB_QtyProformOrigin * rec."Unit Cost";
        //Q13153 +
    end;

    LOCAL procedure SetEditable();
    begin
        Calc_Proform;
        //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
        QRE_seeInsertLineAuto;

        //+Q17327
        JobDescription := '';
        if (Job.GET(Rec."Job No.")) then
            JobDescription := Job.Description;
        //-Q17327
    end;

    LOCAL procedure QRE_seeInsertLineAuto();
    var
        QuoBuildingSetup: Record 7207278;
        PurchaseHeader: Record 38;
    begin
        seeInsertLineAuto := FALSE;
        if (FunctionQB.Job_IsBudget(Rec."Job No.")) then begin
            QuoBuildingSetup.GET;
            PurchaseHeader.RESET;
            PurchaseHeader.SETRANGE("Document Type", Rec."Document Type");
            PurchaseHeader.SETRANGE("No.", Rec."Document No.");
            if (PurchaseHeader.FINDFIRST) then begin
                if (QuoBuildingSetup."QB_QPR Create Auto" <> QuoBuildingSetup."QB_QPR Create Auto"::None) and
                   (PurchaseHeader."QB Budget item" <> '') and
                   (PurchaseHeader."QB Job No." <> '')
                then
                    seeInsertLineAuto := TRUE;
            end;
        end;
    end;

    LOCAL procedure "------------------------------------------ QB Totales"();
    begin
    end;

    LOCAL procedure QB_UpdateLineTotals();
    begin
        //JAV 07/11/22: - QB 1.12.13 Actualizo la pantalla tras calcular l¡neas para que aparezcan las lineas divididas
        if ((rec."QB Splitted Line Date" <> 0D)) then begin
            CurrPage.UPDATE(FALSE);
            exit;
        end;

        //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
        if (Rec.MODIFY(TRUE)) then; // Esto calcula las retenciones al llamar a la siguiente funci¢n el onaftgergetcurrentrecord
    end;

    LOCAL procedure QB_CalculateDocTotals();
    var
        qbPurchaseHeader: Record 38;
        qbPurchaseLine: Record 39;
    begin
        //JAV 18/08/19: - Calculo del total del documento con las retenciones
        if ((qbPurchaseHeader.GET(rec."Document Type", rec."Document No."))) then begin
            qbPurchaseHeader.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

            QB_Base := qbPurchaseHeader.Amount;
            QB_IVA := qbPurchaseHeader."Amount Including VAT" - qbPurchaseHeader.Amount;
            QB_IRPF := qbPurchaseHeader."QW Total Withholding PIT";
            QB_Total := QB_Base + QB_IVA - QB_IRPF;
            QB_Ret := qbPurchaseHeader."QW Total Withholding GE";
            QB_Pagar := QB_Total - QB_Ret;
        end ELSE begin
            QB_Base := 0;
            QB_IVA := 0;
            QB_IRPF := 0;
            QB_Total := 0;
            QB_Ret := 0;
            QB_Pagar := 0;
        end;

        //Calcular el importe de las l¡neas seg£n la cantidad a recibir, proformar y facturar
        QB_BaseAlbaran := 0;
        QB_BaseProforma := 0;
        QB_BaseFactura := 0;
        qbPurchaseLine.RESET;
        qbPurchaseLine.SETRANGE("Document Type", qbPurchaseHeader."Document Type");
        qbPurchaseLine.SETRANGE("Document No.", qbPurchaseHeader."No.");
        if ((qbPurchaseLine.FINDSET(FALSE))) then
            repeat
                //PSM 01/09/21+ se vuelve a usar rec."Direct Unit Cost" y se aplica el descuento, porque rec."Unit Cost" va redondeado
                //PSM 27/05/21+ se cambia rec."Direct Unit Cost" por rec."Unit Cost" que incluye los posibles descuentos
                QB_BaseAlbaran += ROUND(qbPurchaseLine."Qty. to Receive" * qbPurchaseLine."Direct Unit Cost" * (1 - (qbPurchaseLine."Line Discount %" / 100)), 0.01);
                QB_BaseProforma += ROUND(qbPurchaseLine."QB Qty. To Proform" * qbPurchaseLine."Direct Unit Cost" * (1 - (qbPurchaseLine."Line Discount %" / 100)), 0.01);
                QB_BaseFactura += ROUND(qbPurchaseLine."Qty. to Invoice" * qbPurchaseLine."Direct Unit Cost" * (1 - (qbPurchaseLine."Line Discount %" / 100)), 0.01);
            //QB_BaseAlbaran  += ROUND(qbPurchaseLine."Qty. to Receive"    * qbPurchaseLine."Unit Cost", 0.01);
            //QB_BaseProforma += ROUND(qbPurchaseLine."QB Qty. To Proform" * qbPurchaseLine."Unit Cost", 0.01);
            //QB_BaseFactura  += ROUND(qbPurchaseLine."Qty. to Invoice"    * qbPurchaseLine."Unit Cost", 0.01);
            //PSM 27/05/21-
            //PSM 01/09/21-
            until (qbPurchaseLine.NEXT = 0);
    end;

    procedure QB_SetTxtPiecework(Job: Code[20]);
    begin
        if ((Job = '')) then
            Job := Rec."Job No.";

        if ((FunctionQB.Job_IsBudget(Job))) then
            txtPiecework := 'Partida Presupuestaria'
        ELSE
            txtPiecework := 'Unidad de Obra';
        CurrPage.UPDATE(FALSE);
    end;

    //procedure
}


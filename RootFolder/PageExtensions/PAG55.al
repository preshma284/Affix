pageextension 50228 MyExtension55 extends 55//39
{
    layout
    {
        addfirst("PurchDetailLine")
        {
            field("QB_Job"; rec."Job No.")
            {

                ToolTipML = ENU = 'Specif( ies the number of the related job. If you fill in this field and the Job Task No. field,  )then a job ledger entry will be posted together with the purchase line.', ESP = 'Especifica el n£mero del proyecto relacionado. Si rellena este campo y el campo N.§ de unidad de Obra, N§ Partida Presupuestaria o N§ tarea proyecto, se registrar  un movimiento de proyecto junto con la l¡nea de compra.';
                ApplicationArea = Jobs;

                ; trigger OnValidate()
                BEGIN
                    rec.ShowShortcutDimCode(ShortcutDimCode);

                    //JAV 28/04/22: - QB 1.10.37 Refrescar el cambio de dimensi¢n en la pantalla
                    CurrPage.UPDATE;
                END;


            }
            field("QB_PieceworkNo"; rec."Piecework No.")
            {

                CaptionClass = txtPiecework;

                ; trigger OnValidate()
                BEGIN
                    //JAV 28/04/22: - QB 1.10.37 Refrescar el cambio de dimensi¢n en la pantalla
                    rec.ShowShortcutDimCode(ShortcutDimCode);
                    CurrPage.UPDATE;
                END;


            }
            field("QB CA Value"; rec."QB CA Value")
            {

                ToolTipML = ESP = 'Contiene el Concepto anal¡tico que se va a asociar a la l¡nea. Se utiliza en lugar de la dimensi¢n para independizarnos de su n£mero';
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("QB_GenBusPostingGroup"; rec."Gen. Bus. Posting Group")
            {

                Visible = false;
                Editable = edAlbaran;
            }
            field("QB_GenProdPostingGroup"; rec."Gen. Prod. Posting Group")
            {

                Visible = false;
                Editable = edAlbaran;
            }
            field("QB_FrameworkContrNo"; rec."QB Framework Contr. No.")
            {

            }
        }
        addafter("Line Amount")
        {
            field("Receipt No."; rec."Receipt No.")
            {

                Visible = FALSE;
            }
            field("Receipt Line No."; rec."Receipt Line No.")
            {

                Visible = FALSE;
            }
            field("Order No."; rec."Order No.")
            {

                Visible = FALSE;
            }
            field("Order Line No."; rec."Order Line No.")
            {

                Visible = FALSE;
            }
            field("QW Not apply Withholding GE"; rec."QW Not apply Withholding GE")
            {


                ; trigger OnValidate()
                BEGIN
                    //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
                    QB_UpdateLineTotals;
                END;


            }
            field("QW % Withholding by GE"; rec."QW % Withholding by GE")
            {

            }
            field("QW Withholding Amount by GE"; rec."QW Withholding Amount by GE")
            {

            }
            field("QW Not apply Withholding PIT"; rec."QW Not apply Withholding PIT")
            {


                ; trigger OnValidate()
                BEGIN
                    //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
                    QB_UpdateLineTotals;
                END;


            }
            field("QW % Withholding by PIT"; rec."QW % Withholding by PIT")
            {

            }
            field("QW Withholding Amount by PIT"; rec."QW Withholding Amount by PIT")
            {

            }
        }
        addafter("Qty. Assigned")
        {
            //     field("Job No.";rec."Job No.")
            //     {

            //                 ToolTipML=ENU='Specif( ies the number of the related job. If you fill in this field and the Job Task No. field,  )then a job ledger entry will be posted together with the purchase line.',ESP='Especifica el n£mero del proyecto relacionado. Si rellena este campo y el campo N.§ tarea proyecto, se registrar  un movimiento de proyecto junto con la l¡nea de compra.';
            //                 ApplicationArea=Jobs;
            //                 Visible=FALSE;

            //                             ;trigger OnValidate()    BEGIN
            //                              rec.ShowShortcutDimCode(ShortcutDimCode);
            //                            END;


            // }
        }
        addafter("ShortcutDimCode8")
        {
            field("DP_NonDeductibleVATLine"; rec."DP Non Deductible VAT Line")
            {

                ToolTipML = ESP = 'Este campo indica si la l¡nea tiene una parte del IVA no deducible que aumentar  el importe del gasto';
                Visible = seeNonDeductible;
            }
            field("DP_NonDeductibleVATPorc"; rec."DP Non Deductible VAT %")
            {

                ToolTipML = ESP = 'Este campo indica el % no deducible de la l¡nea que aumentar  el improte del gasto';
                Visible = seeNonDeductible;
            }
            field("DP_DeductibleVATLine"; rec."DP Deductible VAT Line")
            {

                ToolTipML = ESP = 'Este campo informa si la l¡nea es o no deducible a efectos de la prorrata de IVA';
                Visible = seeProrrata;
            }
            field("DP_ApplyProrrataType"; rec."DP Apply Prorrata Type")
            {

                Visible = seeProrrata;
            }
            field("DP_ProrrataPerc"; rec."DP Prorrata %")
            {

                Visible = seeProrrata;
            }
            field("DP_IVAOriginalAmountVAT"; rec."DP VAT Amount")
            {

                Visible = seeProrrata;
            }
            field("DP_DeductibleVATAmount"; rec."DP Deductible VAT amount")
            {

                Visible = seeProrrata OR seeNonDeductible;
            }
            field("DP_NonDeductibleVATAmount"; rec."DP Non Deductible VAT amount")
            {

                Visible = seeProrrata OR seeNonDeductible;
            }
        }
        addafter("Control39")
        {
            group("Control1100286010")
            {

                group("Control1100286009")
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
                }
                group("Control1100286005")
                {

                    field("QB_Total"; "QB_Total")
                    {

                        CaptionML = ENU = 'TOTAL', ESP = 'TOTAL FACTURA';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("QB_AdvAm"; "QB_AdvAm")
                    {

                        CaptionML = ESP = 'Anticipo a descontar';
                        Editable = false;
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
                        StyleExpr = TRUE

  ;
                    }
                }
            }
        }


        //modify("Type")
        //{
        //
        //
        //}
        //

        modify("Location Code")
        {
            Visible = seeLocation;


        }


        //modify("Quantity")
        //{
        //
        //
        //}
        //

        modify("Direct Unit Cost")
        {
            Editable = edPrice;


        }


        //modify("Line Discount %")
        //{
        //
        //
        //}
        //

        modify("Control39")
        {
            Visible = false;


        }


        modify("Control33")
        {
            Visible = false;


        }


        modify("Control15")
        {
            Visible = false;


        }

    }

    actions
    {
        addfirst("Processing")
        {
            // action("GetReceiptLines")
            // {

            //     AccessByPermission = TableData 27 = R;
            //     Ellipsis = true;
            //     CaptionML = ENU = '&Get Receipt Lines', ESP = 'Traer albaranes compra';
            //     ToolTipML = ENU = 'Select a posted purchase receipt for the item that you want to assign the item charge to.', ESP = 'Permite seleccionar una recepci¢n de compra registrada para el art¡culo al que desea asignar el coste de producto.';
            //     ApplicationArea = Basic, Suite;
            //     Promoted = true;
            //     Image = Receipt;

            //     trigger OnAction()
            //     BEGIN
            //         COMMIT; // JAV 06/06/22: - QB 1.10.49 Por el RunModal posterior se a¤ade un commit

            //         GetReceipt;
            //         CurrPage.UPDATE;
            //     END;


            // }
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


        // moveafter("ActionContainer1900000004";"&Line")

        // moveafter("&Line";"F&unctions(Action 1906587504),E&xplode BOM(Action 1900205804),InsertExtTexts")

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
                Commit;   //JAV 09/06/22: - QB 1.10.49 Para evitar error de run modal
            END;

        }

    }

    //trigger
    trigger OnOpenPage()
    BEGIN
        //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto    JAV 28/04/22: - QB 1.10.37 Mejora en el manejo de las columas, a¤adimos Real Estate y manejo del Almac‚n

        seeLocation := NOT (FunctionQB.AccessToQuobuilding OR FunctionQB.AccessToBudgets OR FunctionQB.AccessToRealEstate);

        QB_SetTxtPiecework('');
        //QRE15449-INI
        QBPurchLineExt.Read(Rec);
        //QRE15449-FIN

        //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
        seeProrrata := DPManagement.AccessToProrrata;
        //JAV 14/07/22: - DP 1.00.04 Se a¤aden los campos del IVA no deducible
        seeNonDeductible := DPManagement.AccessToNonDeductible;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
        UpdateTypeText;
        SetItemChargeFieldsStyle;

        //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
        QB_SetEditable;
        QRE_seeInsertLineAuto;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        ApplicationAreaMgmtFacade: Codeunit 9179;
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
        GetTotalPurchHeader;
        CalculateTotals;
        UpdateEditableOnRow;
        UpdateTypeText;
        SetItemChargeFieldsStyle;

        //Poner campos editables y Calcular totales del documento
        QB_SetEditable;
        QB_CalculateDocTotals;
        QRE_seeInsertLineAuto;
    END;


    //trigger

    var
        Currency: Record 4;
        PurchasesPayablesSetup: Record 312;
        TotalPurchaseHeader: Record 38;
        TotalPurchaseLine: Record 39;
        TempOptionLookupBuffer: Record 1670 TEMPORARY;
        TransferExtendedText: Codeunit 378;
        ItemAvailFormsMgt: Codeunit 353;
        PurchCalcDiscByType: Codeunit 66;
        DocumentTotals: Codeunit 57;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        AmountWithDiscountAllowed: Decimal;
        IsFoundation: Boolean;
        InvDiscAmountEditable: Boolean;
        IsCommentLine: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        CurrPageIsEditable: Boolean;
        TypeAsText: Text[30];
        ItemChargeStyleExpression: Text;
        "-------------------------------------- QB": Integer;
        FunctionQB: Codeunit 7207272;
        QBPagePublisher: Codeunit 7207348;
        QPRPageSubscriber: Codeunit 7238190;
        PurchHeaderRec: Record 38;
        WithholdingTreating: Codeunit 7207306;
        TotalDocument: Decimal;
        TotalPay: Decimal;
        edPrice: Boolean;
        edAlbaran: Boolean;
        seeLocation: Boolean;
        txtPiecework: Text[80];
        "----------------------------------------------- Prorrata": Integer;
        DPManagement: Codeunit 7174414;
        seeProrrata: Boolean;
        seeNonDeductible: Boolean;
        "------------------------------------ QB Totales": Integer;
        QB_Base: Decimal;
        QB_IVA: Decimal;
        QB_IRPF: Decimal;
        QB_Total: Decimal;
        QB_Ret: Decimal;
        QB_Pagar: Decimal;
        QB_AdvAm: Decimal;
        "-------------------------------------------QRE": Integer;
        QREFunctions: Codeunit 7238197;
        QBPurchLineExt: Record 7238729;
        seeInsertLineAuto: Boolean;



    //procedure
    //procedure ApproveCalcInvDisc();
    //    begin
    //      CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    //      DocumentTotals.PurchaseDocTotalsNotUpToDate;
    //    end;
    //Local procedure ValidateInvoiceDiscountAmount();
    //    var
    //      PurchaseHeader : Record 38;
    //    begin
    //      PurchaseHeader.GET(rec."Document Type",rec."Document No.");
    //      PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchaseHeader);
    //      DocumentTotals.PurchaseDocTotalsNotUpToDate;
    //      CurrPage.UPDATE(FALSE);
    //    end;
    //Local procedure ExplodeBOM();
    //    begin
    //      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    //      DocumentTotals.PurchaseDocTotalsNotUpToDate;
    //    end;
    //Local procedure GetReceipt();
    //    begin
    //      CODEUNIT.RUN(CODEUNIT::"Purch.-Get Receipt",Rec);
    //      DocumentTotals.PurchaseDocTotalsNotUpToDate;
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
    //Local procedure UpdateEditableOnRow();
    //    begin
    //      UnitofMeasureCodeIsChangeable := rec."Type" <> rec."Type"::" ";
    //      IsCommentLine := rec."Type" = rec."Type"::" ";
    //      CurrPageIsEditable := CurrPage.EDITABLE;
    //      InvDiscAmountEditable := CurrPageIsEditable and not PurchasesPayablesSetup."Calc. Inv. Discount";
    //    end;
    Local procedure GetTotalPurchHeader();
    begin
        DocumentTotals.GetTotalPurchaseHeaderAndCurrency(Rec, TotalPurchaseHeader, Currency);
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
    //Local procedure UpdateTypeText();
    //    var
    //      RecRef : RecordRef;
    //    begin
    //      RecRef.GETTABLE(Rec);
    //      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.field(FIELDNO(rec."Type")));
    //    end;
    //Local procedure SetItemChargeFieldsStyle();
    //    begin
    //      ItemChargeStyleExpression := '';
    //      if ( rec.AssignedItemCharge  )then
    //        ItemChargeStyleExpression := 'Unfavorable';
    //    end;
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
    LOCAL procedure "------------------------------------------ QB Totales"();
    begin
    end;

    LOCAL procedure QB_UpdateLineTotals();
    begin
        //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
        if (Rec.MODIFY(TRUE)) then; // Esto calcula las retenciones al llamar a la siguiente funci¢n el onaftgergetcurrentrecord
    end;

    procedure QB_CalculateDocTotals();
    var
        qbPurchaseHeader: Record 38;
    begin
        //JAV 18/08/19: - Calculo del total del documento con las retenciones
        if ((qbPurchaseHeader.GET(rec."Document Type", rec."Document No."))) then begin
            qbPurchaseHeader.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

            QB_Base := qbPurchaseHeader.Amount;
            QB_IVA := qbPurchaseHeader."Amount Including VAT" - qbPurchaseHeader.Amount;
            QB_IRPF := qbPurchaseHeader."QW Total Withholding PIT";
            QB_Total := QB_Base + QB_IVA - QB_IRPF;
            QB_Ret := qbPurchaseHeader."QW Total Withholding GE";
            //Q13154 -
            if (qbPurchaseHeader."QB Prepayment Type" = qbPurchaseHeader."QB Prepayment Type"::Bill) then
                QB_AdvAm := qbPurchaseHeader."QB Prepayment Apply"
            ELSE
                QB_AdvAm := 0;
            //Q13154 +
            QB_Pagar := QB_Total - QB_Ret - QB_AdvAm;
        end ELSE begin
            QB_Base := 0;
            QB_IVA := 0;
            QB_IRPF := 0;
            QB_Total := 0;
            QB_Ret := 0;
            QB_AdvAm := 0;  //Q13154 +
            QB_Pagar := 0;
        end;
    end;

    LOCAL procedure QB_SetEditable();
    begin
        //JAV 05/02/22: - QB 1.10.17 Si viene de un albar n algunos campos no ser n nunca editables
        edAlbaran := (rec."Receipt Line No." = 0);

        //PGM >> GAP 13 Roig CyS Si viene de un albar n no es editable el precio
        if ((FunctionQB.QB_MantContractPricesInFact) and (rec."Receipt Line No." <> 0)) then
            edPrice := FALSE
        ELSE
            edPrice := not IsCommentLine;
        //PGM <<
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

    //procedure
}


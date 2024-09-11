page 7207383 "QB Approvals FactBox"
{
    CaptionML = ENU = 'Approval Document', ESP = 'Documento a aprobar';
    SourceTable = 454;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group19")
            {

                CaptionML = ESP = 'Documento';
                field("DocumentType"; DocumentType)
                {

                    CaptionML = ESP = 'Tipo';
                }
                field("DocumentNo"; DocumentNo)
                {

                    CaptionML = ENU = 'No.', ESP = 'N�';
                }

            }
            group("group22")
            {

                CaptionML = ESP = 'A Pagar';
                Visible = seeCartera;
                field("ExternalDocument"; ExternalDocument)
                {

                    CaptionML = ENU = 'Extrernal Document', ESP = 'Documento Externo';
                    Visible = seeCartera;
                }
                field("OrderNo"; OrderNo)
                {

                    CaptionML = ENU = 'Order No.', ESP = 'Pedido/Contrato';
                    Visible = seeCartera;

                    ; trigger OnDrillDown()
                    BEGIN
                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("No.", OrderNo);
                        IF PurchaseHeader.FINDFIRST THEN BEGIN
                            PAGE.RUN(0, PurchaseHeader);
                        END;
                    END;


                }
                field("Cartera ActivityCode"; ActivityCode)
                {

                    CaptionML = ENU = 'Activity Code', ESP = 'C�d. Actividad';
                    Visible = seeCartera;
                }
                field("Cartera ActivityDescription"; ActivityDescription)
                {

                    CaptionML = ENU = 'Activity Description', ESP = 'Descr. Actividad';
                    Visible = seeCartera;
                }
                field("Base"; BaseAmount)
                {

                    CaptionML = ESP = 'Base Imponible';
                    BlankZero = true;
                }
                field("Total"; rec."Amount")
                {

                    CaptionML = ENU = 'Amount', ESP = 'Total Factura';
                    BlankZero = true;
                    Visible = seeComparative;
                }

            }
            group("group29")
            {

                CaptionML = ESP = 'Comparativos';
                Visible = seeComparative;
                field("ActivityCode"; ActivityCode)
                {

                    CaptionML = ENU = 'Activity Code', ESP = 'C�d. Actividad';
                    Visible = seeComparative;
                }
                field("ActivityDescription"; ActivityDescription)
                {

                    CaptionML = ENU = 'Activity Description', ESP = 'Descr. Actividad';
                    Visible = seeComparative;
                }
                field("Job No."; rec."Job No.")
                {

                    Visible = seeComparative;
                }
                field("SelectedVendorCode"; SelectedVendorCode)
                {

                    CaptionML = ENU = 'Selected Vendor Code', ESP = 'C�d. Prov. Seleccionado';
                    Visible = seeComparative;
                }
                field("SelectedVendorName"; SelectedVendorName)
                {

                    CaptionML = ENU = 'Selected Vendor Name', ESP = 'Nombre Prov. Seleccionado';
                    Visible = seeComparative;
                }
                field("Amount"; rec."Amount")
                {

                    Visible = seeComparative;
                }
                field("EstimatedAmount"; EstimatedAmount)
                {

                    CaptionML = ENU = 'Estimated Amount', ESP = 'Imp. Estimado';
                    Visible = seeComparative;
                }
                field("ReferenceAmount"; SecondAmount)
                {

                    CaptionML = ENU = 'Reference Amount', ESP = 'Imp';
                    CaptionClass = txtSecondAmount

  ;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        SeeCartera := TRUE;
        SeeComparative := TRUE;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF (rec."Entry No." <> 0) THEN
            CalcData;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        IF (rec."Entry No." <> 0) THEN
            CalcData;
    END;



    var
        CarteraDoc: Record 7000002;
        ActivityQB: Record 7207280;
        PurchaseHeader: Record 38;
        Job: Record 167;
        ComparativeQuoteHeader: Record 7207412;
        Vendor: Record 23;
        PurchInvHeader: Record 122;
        PurchInvLine: Record 123;
        FunctionQB: Codeunit 7207272;
        EntryNo: Integer;
        ExternalDocument: Code[20];
        OrderNo: Code[20];
        ActivityCode: Code[20];
        ActivityDescription: Text;
        SelectedVendorCode: Code[20];
        SelectedVendorName: Text;
        EstimatedAmount: Decimal;
        SecondAmount: Decimal;
        BaseAmount: Decimal;
        DocumentType: Text;
        DocumentNo: Text;
        SeeCartera: Boolean;
        SeeComparative: Boolean;
        txtSecondAmount: Text;

    procedure ClearData();
    begin
        CLEARALL;
        CLEAR(Rec);
    end;

    LOCAL procedure CalcData();
    begin
        if (rec."QB Document Type" <> rec."QB Document Type"::" ") then
            DocumentType := FORMAT(rec."QB Document Type")
        ELSE
            DocumentType := FORMAT(rec."Document Type");
        DocumentNo := rec."Document No.";

        SeeCartera := FALSE;
        SeeComparative := FALSE;
        CASE rec."QB Document Type" OF
            rec."QB Document Type"::Payment:
                CalcCartera;
            rec."QB Document Type"::Comparative:
                CalcComparative;
        end;

        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure CalcCartera();
    var
        rRef: RecordRef;
        fRef: FieldRef;
    begin
        SeeCartera := TRUE;

        DocumentNo := '';
        ExternalDocument := '';
        ActivityCode := '';
        ActivityDescription := '';
        BaseAmount := 0;

        EVALUATE(EntryNo, Rec."Document No.");
        if CarteraDoc.GET(CarteraDoc.Type::Payable, rec."Entry No.") then begin
            DocumentNo := CarteraDoc."Document No.";
            CarteraDoc.CALCFIELDS("External Document No.");
            ExternalDocument := CarteraDoc."External Document No.";

            if FunctionQB.AccessToComparativeReferences then begin
                rRef.GETTABLE(CarteraDoc);
                fRef := rRef.FIELD(50005);
                ActivityCode := FORMAT(fRef.VALUE);
                if ActivityQB.GET(ActivityCode) then
                    ActivityDescription := ActivityQB.Description;
            end;

            OrderNo := '';
            ActivityCode := '';
            ActivityDescription := '';
            if (PurchInvHeader.GET(DocumentNo)) then begin
                PurchInvHeader.CALCFIELDS(Amount);
                BaseAmount := PurchInvHeader.Amount;

                OrderNo := PurchInvHeader."Contract No.";
                if (OrderNo = '') then
                    OrderNo := PurchInvHeader."Order No.";
                if (OrderNo = '') then begin
                    PurchInvLine.RESET;
                    PurchInvLine.SETRANGE("Document No.", DocumentNo);
                    PurchInvLine.SETFILTER("Order No.", '<>%1', '');
                    if (PurchInvLine.FINDFIRST) then
                        OrderNo := PurchInvLine."Order No.";
                end;
            end;
        end;
    end;

    LOCAL procedure CalcComparative();
    var
        ComparativeQuoteLines: Record 7207413;
        rRef: RecordRef;
        fRef1: FieldRef;
        fRef2: FieldRef;
        dec: Decimal;
    begin
        SeeComparative := TRUE;
        txtSecondAmount := 'Imp. Objetivo';

        EstimatedAmount := 0;
        SecondAmount := 0;

        if (ComparativeQuoteHeader.GET(rec."Document No.")) then begin
            ActivityCode := COPYSTR(ComparativeQuoteHeader."Activity Filter", 1, MAXSTRLEN(ActivityCode));  //JAV 07/11/22: - QB 1.12.15 Evitar errores de desbordamiento en actividades
            ActivityDescription := ComparativeQuoteHeader.GetDescriptionActivity;
            SelectedVendorCode := ComparativeQuoteHeader."Selected Vendor";
            if Vendor.GET(ComparativeQuoteHeader."Selected Vendor") then
                SelectedVendorName := Vendor.Name;

            ComparativeQuoteLines.RESET;
            ComparativeQuoteLines.SETRANGE("Quote No.", rec."Document No.");
            ComparativeQuoteLines.CALCSUMS("Estimated Amount", "Target Amount");
            EstimatedAmount := ComparativeQuoteLines."Estimated Amount";
            SecondAmount := ComparativeQuoteLines."Target Amount";

            if FunctionQB.AccessToComparativeReferences then begin
                txtSecondAmount := 'Imp. Referencia';

                rRef.OPEN(50010);
                fRef1 := rRef.FIELD(2);   //Campo "Quote No."
                fRef2 := rRef.FIELD(13);  //Campo "Estimated Amount"

                rRef.RESET;
                fRef1.SETRANGE(rec."Document No.");
                if (rRef.FINDSET(FALSE)) then
                    repeat
                        EVALUATE(dec, FORMAT(fRef2.VALUE));
                        SecondAmount += dec;
                    until (rRef.NEXT = 0);

                rRef.CLOSE;
            end;

        end;
    end;

    // begin
    /*{
      JAV 19/04/22: - QB 1.10.36 Se a�ade el caption al campo DocumentNo
      JAV 07/11/22: - QB 1.12.15 Evitar errores de desbordamiento en actividades
    }*///end
}








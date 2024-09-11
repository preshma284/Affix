report 7207458 "QB Vendor Situation"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Situaci¢n proveedor (QB)', ESP = 'QB Vendor Situation';

    dataset
    {

        DataItem("Vendor"; "Vendor")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            Column(TitleN; Title)
            {
                //SourceExpr=Title;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(TotalCaptionName; TotalCaptionLbl)
            {
                //SourceExpr=TotalCaptionLbl;
            }
            Column(VendorFilters; VendFilters)
            {
                //SourceExpr=VendFilters;
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(Vendor_TABLECAPTION; Vendor.TABLECAPTION)
            {
                //SourceExpr=Vendor.TABLECAPTION;
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(VENDOR__TABLECAPTION__________VendorFilters; Vendor.TABLECAPTION + ': ' + VendFilters)
            {
                //SourceExpr=Vendor.TABLECAPTION + ': ' + VendFilters;
            }
            Column(No; Vendor."No.")
            {
                //SourceExpr=Vendor."No.";
            }
            Column(Name; Vendor.Name + Vendor."Name 2")
            {
                //SourceExpr=Vendor.Name+Vendor."Name 2";
            }
            Column(AlbPdte; RecibidoNoFact)
            {
                //SourceExpr=RecibidoNoFact;
            }
            Column(FrasPdtes; FacturasPdtesLCY)
            {
                //SourceExpr=FacturasPdtesLCY;
            }
            Column(EfectPdtesPago; EfPdtesPagoLCY)
            {
                //SourceExpr=EfPdtesPagoLCY;
            }
            Column(RetencPdtes; Vendor."QW Withholding Pending Amount")
            {
                //SourceExpr=Vendor."QW Withholding Pending Amount";
            }
            Column(AnticPdtes; Vendor."QB Prepayment Amount (LCY)")
            {
                //SourceExpr=Vendor."QB Prepayment Amount (LCY)";
            }
            Column(Total1; Total1)
            {
                //SourceExpr=Total1;
            }
            Column(EfectPdtesEnCartera; EfPdtesCarteraLCY)
            {
                //SourceExpr=EfPdtesCarteraLCY;
            }
            Column(Total2; Total2)
            {
                //SourceExpr=Total2 ;
            }
            trigger OnPreDataItem();
            BEGIN
                VendFilters := Vendor.GETFILTERS;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF (opcFechas <> '') THEN
                    Vendor.SETFILTER("Date Filter", opcFechas);
                Vendor.CALCFIELDS("QB Prepayment Amount (LCY)", "QW Withholding Pending Amount", "Amt. Rcd. Not Invoiced (LCY)");

                //RecibidoNoFact := Vendor."Amt. Rcd. Not Invoiced (LCY)";

                //FacturasPdtesLCY := CalcRemainingAmt(2,FALSE);
                //FacturasPdtesLCY := FacturasPdtesLCY + CalcRemainingAmt(3,FALSE);

                //EfPdtesPagoLCY := CalcRemainingAmt(21,FALSE);
                //EfPdtesCarteraLCY := CalcRemainingAmt(21,TRUE);

                RecibidoNoFact := Vendor."Amt. Rcd. Not Invoiced (LCY)";
                EfPdtesPagoLCY := CalcRemainingAmtTotal(1);
                FacturasPdtesLCY := CalcRemainingAmtTotal(0) - EfPdtesPagoLCY;
                Total1 := RecibidoNoFact + FacturasPdtesLCY + EfPdtesPagoLCY + Vendor."QW Withholding Pending Amount" - Vendor."QB Prepayment Amount (LCY)";
                EfPdtesCarteraLCY := CalcRemainingAmtTotal(2);
                Total2 := Total1 + EfPdtesCarteraLCY;

                IF (Total2 = 0) AND (NOT opcAll) THEN
                    CurrReport.SKIP;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group983")
                {

                    CaptionML = ESP = 'Opciones';
                    field("opcFechas"; "opcFechas")
                    {

                        CaptionML = ESP = 'Filtro Fechas';
                    }
                    field("opcProyectos"; "opcProyectos")
                    {

                        CaptionML = ESP = 'Filtro Proyectos';
                    }
                    field("opcAll"; "opcAll")
                    {

                        CaptionML = ESP = 'Ver con saldo cero';
                    }

                }

            }
        }
    }
    labels
    {
        C01 = 'C¢digo/';
        C02 = 'Nombre/';
        C03 = 'Albaranes Ptes. Fra./';
        C04 = 'Facturas Ptes./';
        C08 = 'Efectos en Cartera/';
        C05 = 'Retenciones Ptes./';
        C06 = 'Anticipos Ptes./';
        C07 = 'Total Pte. Pago/';
        C09 = 'Efectos Registrados/';
        C10 = 'Total/';
    }

    var
        //       Title@1100286000 :
        Title: TextConst ENU = 'VENDOR STATUS', ESP = 'SITUACIàN DE PROVEEDORES';
        //       CurrReport_PAGENOCaptionLbl@1100286012 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       TotalCaptionLbl@1100286004 :
        TotalCaptionLbl: TextConst ENU = 'Total  (suma *)', ESP = 'Totales';
        //       VendFilters@1100286002 :
        VendFilters: Text;
        //       FacturasPdtesLCY@1100286003 :
        FacturasPdtesLCY: Decimal;
        //       EfPdtesPagoLCY@1100286005 :
        EfPdtesPagoLCY: Decimal;
        //       EfPdtesCarteraLCY@1100286006 :
        EfPdtesCarteraLCY: Decimal;
        //       RecibidoNoFact@1100286007 :
        RecibidoNoFact: Decimal;
        //       Total1@1100286011 :
        Total1: Decimal;
        //       Total2@1100286013 :
        Total2: Decimal;
        //       "------------------------------- Opciones"@1100286008 :
        "------------------------------- Opciones": Integer;
        //       opcFechas@1100286009 :
        opcFechas: Text;
        //       opcProyectos@1100286010 :
        opcProyectos: Text;
        //       opcAll@1100286014 :
        opcAll: Boolean;

    //     LOCAL procedure CalcRemainingAmt (pDocumentType@1100286001 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,Currency Shipment,WIP,,,,,,,,,,Bill';pFiltDocSituation@1100286002 :
    LOCAL procedure CalcRemainingAmt(pDocumentType: Option " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund","Currency Shipment","WIP","Bill"; pFiltDocSituation: Boolean): Decimal;
    var
        //       VendLedgEntry@1100286000 :
        VendLedgEntry: Record 25;
        //       TotAmt@1100286003 :
        TotAmt: Decimal;
    begin
        //ESP=" ,Pago,Factura,Abono,Docs. inter‚s,Recordatorio,Reembolso,,,,Dif.Cambio Albar nAlbar n,OEC,,,,,,,,,,Efecto"

        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Document Type", "Document Situation", "Document Status");
        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        if pDocumentType = pDocumentType::Bill then
            VendLedgEntry.SETFILTER("Document Type", '%1|%2', pDocumentType, VendLedgEntry."Document Type"::Invoice)
        else
            VendLedgEntry.SETRANGE("Document Type", pDocumentType);
        if pFiltDocSituation then
            //VendLedgEntry.SETFILTER("Document Situation",'%1|%2|%3',VendLedgEntry."Document Situation"::" ",
            //          VendLedgEntry."Document Situation"::"BG/PO",VendLedgEntry."Document Situation"::Cartera);
            VendLedgEntry.SETFILTER("Document Situation", '%1|%2|%3', VendLedgEntry."Document Situation"::"Closed BG/PO",
                  VendLedgEntry."Document Situation"::"Closed Documents", VendLedgEntry."Document Situation"::"Posted BG/PO");

        if pDocumentType = pDocumentType::Bill then
            VendLedgEntry.SETRANGE("Document Status", VendLedgEntry."Document Status"::Open);

        if (Vendor.GETFILTER(Vendor."Date Filter") <> '') then
            VendLedgEntry.SETFILTER("Posting Date", Vendor.GETFILTER(Vendor."Date Filter"));
        if (Vendor.GETFILTER(Vendor."Global Dimension 1 Filter") <> '') then
            VendLedgEntry.SETFILTER("Global Dimension 1 Code", Vendor.GETFILTER(Vendor."Global Dimension 1 Filter"));
        if (Vendor.GETFILTER(Vendor."Global Dimension 2 Filter") <> '') then
            VendLedgEntry.SETFILTER("Global Dimension 2 Code", Vendor.GETFILTER(Vendor."Global Dimension 2 Filter"));

        //VendLedgEntry.CALCSUMS("Amount (LCY) stats.","Remaining Amount (LCY) stats.");
        //exit(- VendLedgEntry."Remaining Amount (LCY) stats.");

        TotAmt := 0;
        if VendLedgEntry.FINDFIRST then
            repeat
                VendLedgEntry.CALCFIELDS(VendLedgEntry."Remaining Amt. (LCY)");
                TotAmt := TotAmt + VendLedgEntry."Remaining Amt. (LCY)";
            until VendLedgEntry.NEXT = 0;

        exit(-TotAmt);
    end;

    //     LOCAL procedure CalcRemainingAmtTotal (pTotal@1100286002 :
    LOCAL procedure CalcRemainingAmtTotal(pTotal: Option "All","Cartera","Remesados"): Decimal;
    var
        //       VendorLedgerEntry@1100286000 :
        VendorLedgerEntry: Record 25;
        //       Suma@1100286003 :
        Suma: Decimal;
    begin
        Suma := 0;

        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Document Type", "Document Situation", "Document Status");
        VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendorLedgerEntry.SETRANGE(Open, TRUE);
        CASE pTotal OF
            pTotal::All:
                VendorLedgerEntry.SETFILTER("Document Situation", '%1|%2|%3', VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera, VendorLedgerEntry."Document Situation"::"BG/PO");
            pTotal::Cartera:
                VendorLedgerEntry.SETFILTER("Document Situation", '%1', VendorLedgerEntry."Document Situation"::Cartera);
            pTotal::Remesados:
                VendorLedgerEntry.SETFILTER("Document Situation", '%1', VendorLedgerEntry."Document Situation"::"Posted BG/PO");
        end;

        if (opcFechas <> '') then
            VendorLedgerEntry.SETFILTER("Posting Date", opcFechas);
        if (opcProyectos <> '') then
            VendorLedgerEntry.SETFILTER("QB Job No.", opcProyectos);

        if (VendorLedgerEntry.FINDSET(FALSE)) then
            repeat
                VendorLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                Suma += VendorLedgerEntry."Remaining Amt. (LCY)";
            until VendorLedgerEntry.NEXT = 0;
        exit(-Suma);  //En proveedores el saldo es negativo
    end;

    /*begin
    //{
//      17216 CSM 09/06/22 Í Informe saldos de proveedores.
//    }
    end.
  */

}





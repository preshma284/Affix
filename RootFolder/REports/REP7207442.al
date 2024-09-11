report 7207442 "Location 2"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Location', ESP = 'Almac‚n';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterHeadingML = ESP = 'Obra';


            RequestFilterFields = "No.", "Posting Date Filter";
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(JobText; JobText + ':')
            {
                //SourceExpr=JobText+':';
            }
            Column(FilterPeriod; FilterPeriod)
            {
                //SourceExpr=FilterPeriod;
            }
            Column(TotalText; TotalText)
            {
                //SourceExpr=TotalText;
            }
            Column(JobNo; "No.")
            {
                //SourceExpr="No.";
            }
            Column(JobDesc; Description)
            {
                //SourceExpr=Description;
            }
            Column(JobDesc2; "Description 2")
            {
                //SourceExpr="Description 2";
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaption)
            {
                //SourceExpr=CurrReport_PAGENOCaption;
            }
            Column(LocationCaption; LocationCaption)
            {
                //SourceExpr=LocationCaption;
            }
            DataItem("Item"; "Item")
            {

                DataItemTableView = SORTING("No.")
                                 ORDER(Ascending);


                RequestFilterFields = "No.", "Inventory Posting Group", "Gen. Prod. Posting Group";
                Column(ItemNo; "No.")
                {
                    //SourceExpr="No.";
                }
                Column(ItemDescription; Description)
                {
                    IncludeCaption = true;
                    //SourceExpr=Description;
                }
                Column(ItemUnitMeasure; "Base Unit of Measure")
                {
                    //SourceExpr="Base Unit of Measure";
                }
                Column(EntOri; decEntOrig)
                {
                    //SourceExpr=decEntOrig;
                }
                Column(EntOriVal; decValEntOrig)
                {
                    //SourceExpr=decValEntOrig;
                }
                Column(EntPer; decEntPer)
                {
                    //SourceExpr=decEntPer;
                }
                Column(EntPerVal; decValEntPer)
                {
                    //SourceExpr=decValEntPer;
                }
                Column(SalOri; -decSalOrig)
                {
                    //SourceExpr=- decSalOrig;
                }
                Column(SalOriVal; -decValSalOrig)
                {
                    //SourceExpr=- decValSalOrig;
                }
                Column(SalPer; -decSalPer)
                {
                    //SourceExpr=- decSalPer;
                }
                Column(SalPerVal; -decValSalPer)
                {
                    //SourceExpr=- decValSalPer;
                }
                Column(Tot; decSaldo)
                {
                    //SourceExpr=decSaldo;
                }
                Column(TotVal; decValSaldo)
                {
                    //SourceExpr=decValSaldo ;
                }
                trigger OnAfterGetRecord();
                BEGIN
                    decEntOrig := 0;
                    decEntPer := 0;
                    decSalOrig := 0;
                    decSalPer := 0;
                    decValEntOrig := 0;
                    decValEntPer := 0;
                    decValSalOrig := 0;
                    decValSalPer := 0;
                    decSaldo := 0;
                    decValSaldo := 0;

                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETCURRENTKEY("Item No.", "Entry Type", Positive, "Posting Date", "Location Code");
                    ItemLedgerEntry.SETRANGE("Item No.", "No.");
                    ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
                    IF NOT ItemLedgerEntry.FINDFIRST THEN
                        CurrReport.SKIP;

                    REPEAT
                        ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");

                        // Origen
                        IF (ItemLedgerEntry."Posting Date" < StartDate) THEN BEGIN
                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase) OR
                               (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Positive Adjmt.") THEN BEGIN
                                decEntOrig := decEntOrig + ItemLedgerEntry.Quantity;
                                decValEntOrig := decValEntOrig + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                            END;

                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) OR
                               (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Negative Adjmt.") THEN BEGIN
                                decSalOrig := decSalOrig + ItemLedgerEntry.Quantity;
                                ;
                                decValSalOrig := decValSalOrig + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                            END;

                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Transfer) THEN BEGIN
                                IF ItemLedgerEntry.Positive THEN BEGIN
                                    decEntOrig := decEntOrig + ItemLedgerEntry.Quantity;
                                    decValEntOrig := decValEntOrig + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                                END ELSE BEGIN
                                    decSalOrig := decSalOrig + ItemLedgerEntry.Quantity;
                                    decValSalOrig := decValSalOrig + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                                END;
                            END;

                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Negative Adjmt.") THEN BEGIN
                                IF (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt") OR
                                   (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Invoice") OR
                                   (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Credit Memo") THEN BEGIN
                                    decEntOrig := decEntOrig + ItemLedgerEntry.Quantity;
                                    decValEntOrig := decValEntOrig + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                                    decSalOrig := decSalOrig - ItemLedgerEntry.Quantity;
                                    decValSalOrig := decValSalOrig - (ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)");
                                END;
                            END;

                        END;

                        //Periodo
                        IF (ItemLedgerEntry."Posting Date" >= StartDate) AND (ItemLedgerEntry."Posting Date" <= Enddate) THEN BEGIN
                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase) OR
                               (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Positive Adjmt.") THEN BEGIN
                                decEntPer := decEntPer + ItemLedgerEntry.Quantity;
                                decValEntPer := decValEntPer + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                            END;

                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) OR
                               (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Negative Adjmt.") THEN BEGIN
                                decSalPer := decSalPer + ItemLedgerEntry.Quantity;
                                ;
                                decValSalPer := decValSalPer + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                            END;

                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Transfer) THEN BEGIN
                                IF ItemLedgerEntry.Positive THEN BEGIN
                                    decEntPer := decEntPer + ItemLedgerEntry.Quantity;
                                    decValEntPer := decValEntPer + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                                END ELSE BEGIN
                                    decSalPer := decSalPer + ItemLedgerEntry.Quantity;
                                    decValSalPer := decValSalPer + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                                END;
                            END;

                            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Negative Adjmt.") THEN BEGIN
                                IF (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt") OR
                                   (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Invoice") OR
                                   (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Credit Memo") THEN BEGIN
                                    decEntPer := decEntPer + ItemLedgerEntry.Quantity;
                                    decValEntPer := decValEntPer + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                                    decSalPer := decSalPer - ItemLedgerEntry.Quantity;
                                    decValSalPer := decValSalPer - (ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)");
                                END;
                            END;
                        END;

                        // Saldo a fecha
                        IF ItemLedgerEntry."Posting Date" <= Enddate THEN BEGIN
                            decSaldo := decSaldo + ItemLedgerEntry.Quantity;
                            decValSaldo := decValSaldo + ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                        END;
                    UNTIL ItemLedgerEntry.NEXT = 0;

                    IF (decEntOrig = 0) AND (decEntPer = 0) AND (decSalOrig = 0) AND (decSalPer = 0) THEN
                        CurrReport.SKIP;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);


                IF (Job.GETFILTER("Posting Date Filter") <> '') THEN BEGIN
                    StartDate := GETRANGEMIN("Posting Date Filter");
                    Enddate := GETRANGEMAX("Posting Date Filter");
                END;

                //IF ((Job.GETFILTER(Job."Posting Date Filter") = '') OR (StartDate = Enddate)) THEN
                //  ERROR(Text0001);
                IF ((Job.GETFILTER(Job."Posting Date Filter") = '') OR (StartDate = Enddate)) THEN BEGIN
                    StartDate := 0D;
                    Enddate := TODAY;
                    FilterPeriod := 'Todas las fechas';
                END ELSE
                    FilterPeriod := Job.GETFILTER(Job."Posting Date Filter");

                Job.SETFILTER("Job Location", '<>%1', '');
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF "Matrix Job it Belongs" <> '' THEN BEGIN
                    JobText := Text0002;
                    TotalText := Text0003;
                END ELSE BEGIN
                    JobText := Text0004;
                    TotalText := Text0005;
                END
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
        Period = 'Period:/ Per¡odo:/';
        Total = 'Total general:/';
        StockIni = 'Exist. Ant./';
        StockFin = 'Exis. Final/';
        lblProd = 'Producto/';
        lblDes = 'Descripci¢n/';
        lblUM = 'U.M./';
        lblEntradas = 'Entradas/';
        lblEntOri = 'Anteriores/';
        lblEntOriVal = 'Importe Ant./';
        lblEntPer = 'Periodo/';
        lblEntPerVal = 'Importe Per./';
        lblSalidas = 'Salidas/';
        lblSalAnt = 'Anteriores/';
        lblSalAntVal = 'Importe Ant./';
        lblSalPer = 'Periodo/';
        lblSalPerVal = 'Importe Per./';
        lblTotal = 'Total/';
        lblTot = 'Saldo/';
        lblTotVal = 'Importe Tot./';
    }

    var
        //       CompanyInformation@1000000008 :
        CompanyInformation: Record 79;
        //       ItemLedgerEntry@1000000005 :
        ItemLedgerEntry: Record 32;
        //       StartDate@7001115 :
        StartDate: Date;
        //       Enddate@7001114 :
        Enddate: Date;
        //       JobText@7001113 :
        JobText: Text[30];
        //       TotalText@7001112 :
        TotalText: Text[30];
        //       FilterPeriod@7001111 :
        FilterPeriod: Text[30];
        //       LocationCaption@7001125 :
        LocationCaption: TextConst ENU = 'Location', ESP = 'Almac‚n';
        //       CurrReport_PAGENOCaption@7001124 :
        CurrReport_PAGENOCaption: TextConst ENU = 'Page', ESP = 'P g.';
        //       Text0002@7001127 :
        Text0002: TextConst ENU = 'Record', ESP = 'Expediente';
        //       Text0003@7001128 :
        Text0003: TextConst ENU = 'Total Record', ESP = 'Total Expediente';
        //       Text0004@7001129 :
        Text0004: TextConst ENU = 'Work', ESP = 'PROYECTO N§';
        //       Text0005@7001130 :
        Text0005: TextConst ENU = 'Total Job', ESP = 'Total obra';
        //       ItemNameCaption@7001131 :
        ItemNameCaption: TextConst ENU = 'Name', ESP = 'Descripci¢n';
        //       decEntOrig@10011 :
        decEntOrig: Decimal;
        //       decEntPer@10012 :
        decEntPer: Decimal;
        //       decSalOrig@10013 :
        decSalOrig: Decimal;
        //       decSalPer@10014 :
        decSalPer: Decimal;
        //       decValEntOrig@10015 :
        decValEntOrig: Decimal;
        //       decValEntPer@10016 :
        decValEntPer: Decimal;
        //       decValSalOrig@10017 :
        decValSalOrig: Decimal;
        //       decValSalPer@10018 :
        decValSalPer: Decimal;
        //       decSaldo@10021 :
        decSaldo: Decimal;
        //       decValSaldo@10022 :
        decValSaldo: Decimal;

    /*begin
    end.
  */

}



// RequestFilterFields="No.","Inventory Posting Group","Gen. Prod. Posting Group";


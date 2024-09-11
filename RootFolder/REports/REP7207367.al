report 7207367 "Location"
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
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(JobText; JobText + ':')
            {
                //SourceExpr=JobText+':';
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
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
            Column(ItemCaption; ItemCaption)
            {
                //SourceExpr=ItemCaption;
            }
            Column(ItemNameCaption; ItemNameCaption)
            {
                //SourceExpr=ItemNameCaption;
            }
            Column(UMCaption; UMCaption)
            {
                //SourceExpr=UMCaption;
            }
            Column(PreviousStockCaption; PreviousStockCaption)
            {
                //SourceExpr=PreviousStockCaption;
            }
            Column(EntriesCaption; EntriesCaption)
            {
                //SourceExpr=EntriesCaption;
            }
            Column(OutputsCaption; OutputsCaption)
            {
                //SourceExpr=OutputsCaption;
            }
            Column(StockperiodCaption; StockperiodCaption)
            {
                //SourceExpr=StockperiodCaption;
            }
            Column(HalfpriceCaption; HalfpriceCaption)
            {
                //SourceExpr=HalfpriceCaption;
            }
            Column(AssessmentCaption; AssessmentCaption)
            {
                //SourceExpr=AssessmentCaption;
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
                Column(PreviousStock; PreviousStock)
                {
                    DecimalPlaces = 0 : 5;
                    //SourceExpr=PreviousStock;
                }
                Column(Entry; "QB Entry (units)")
                {
                    DecimalPlaces = 0 : 5;
                    //SourceExpr="QB Entry (units)";
                }
                Column(Out; -"QB Output (units)")
                {
                    DecimalPlaces = 0 : 5;
                    //SourceExpr=- "QB Output (units)";
                }
                Column(Stockperiod; Stockperiod)
                {
                    DecimalPlaces = 0 : 5;
                    //SourceExpr=Stockperiod;
                }
                Column(HalfPrice; HalfPrice)
                {
                    DecimalPlaces = 0 : 5;
                    //SourceExpr=HalfPrice;
                }
                Column(Value; "QB Location Sum Cost Amount")
                {
                    DecimalPlaces = 0 : 5;
                    //SourceExpr="QB Location Sum Cost Amount" ;
                }
                trigger OnAfterGetRecord();
                VAR
                    //                                   Cost@1100286000 :
                    Cost: Decimal;
                    //                                   Qty@1100286001 :
                    Qty: Decimal;
                    //                                   GeneralLedgerSetup@1100286002 :
                    GeneralLedgerSetup: Record 98;
                BEGIN
                    IF FirstLine THEN
                        FirstLine := FALSE
                    ELSE
                        CLEAR(CompanyInformation.Picture);
                    GeneralLedgerSetup.GET;
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETCURRENTKEY("Item No.", "Location Code");
                    ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                    ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
                    IF (ItemLedgerEntry.ISEMPTY) THEN
                        CurrReport.SKIP
                    ELSE BEGIN
                        //Filtro del almac‚n
                        SETFILTER("Location Filter", Job."Job Location");

                        //Calculo del stock anterior
                        IF StartDate <> 0D THEN BEGIN
                            SETFILTER("Date Filter", '%1..%2', 0D, (StartDate - 1));
                            CALCFIELDS("Net Change");
                            PreviousStock := "Net Change";
                        END ELSE
                            PreviousStock := 0;

                        SETFILTER("Date Filter", '%1..%2', StartDate, Enddate);

                        //Ver si tiene que sacar los datos
                        CALCFIELDS("QB Entry (units)", "QB Output (units)");

                        IF (PreviousStock = 0) AND ("QB Entry (units)" = 0) AND ("QB Output (units)" = 0) THEN
                            CurrReport.SKIP
                        ELSE BEGIN
                            Stockperiod := PreviousStock + "QB Entry (units)" + "QB Output (units)";
                            Cost := 0;
                            Qty := 0;
                            HalfPrice := 0;
                            ItemLedgerEntry2.RESET;
                            ItemLedgerEntry2.SETCURRENTKEY("Item No.", "Location Code");
                            ItemLedgerEntry2.SETRANGE("Item No.", Item."No.");
                            ItemLedgerEntry2.SETRANGE("Location Code", Job."Job Location");
                            ItemLedgerEntry2.SETRANGE("Posting Date", 0D, Enddate);
                            IF ItemLedgerEntry2.FINDSET THEN
                                REPEAT
                                    ItemLedgerEntry2.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                                    Cost += ItemLedgerEntry2."Cost Amount (Expected)" + ItemLedgerEntry2."Cost Amount (Actual)";
                                    Qty += ItemLedgerEntry2.Quantity;
                                UNTIL ItemLedgerEntry2.NEXT = 0;
                            IF Qty <> 0 THEN HalfPrice := ROUND(Cost / Qty, GeneralLedgerSetup."Unit-Amount Rounding Precision");
                            //{
                            //                                      SETRANGE("Date Filter");
                            //                                      SETFILTER("Date Filter",'%1..%2',0D,Enddate);
                            //
                            //                                      Item.CALCFIELDS("QB Location Sum Cost Amount", "QB Location Sum Cost Qty","QB Location Sum Cost Am.Exp");
                            //                                      IF ("QB Location Sum Cost Qty" <> 0) THEN
                            //                                        HalfPrice := ROUND(("QB Location Sum Cost Amount" + "QB Location Sum Cost Am.Exp") / "QB Location Sum Cost Qty", 0.00001)
                            //                                      ELSE
                            //                                        HalfPrice := 0;
                            //                                     }
                        END;

                    END;
                    //+Q19460
                    IF OmitirValor0 THEN
                        IF Stockperiod * HalfPrice = 0 THEN
                            CurrReport.SKIP;
                    //-Q19460
                END;


            }
            trigger OnPreDataItem();
            BEGIN
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

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);

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
            area(content)
            {
                group("Options")
                {

                    CaptionML = ESP = 'Opciones';
                    field("OmitirValor0"; "OmitirValor0")
                    {

                        CaptionML = ENU = 'Skip value 0', ESP = 'Omitir valocaci¢n 0';
                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            OmitirValor0 := TRUE; //Q19460
        END;


    }
    labels
    {
        Period = 'Period:/ Per¡odo:/';
        Total = 'Total general:/';
        StockIni = 'Exist. Ant./';
        StockFin = 'Exis. Final/';
    }

    var
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
        //       CompanyInformation@7001110 :
        CompanyInformation: Record 79;
        //       PreviousStock@7001109 :
        PreviousStock: Decimal;
        //       Stockperiod@7001106 :
        Stockperiod: Decimal;
        //       HalfPrice@7001105 :
        HalfPrice: Decimal;
        //       HalfPriceDA@7001104 :
        HalfPriceDA: Decimal;
        //       ItemCostManagement@7001102 :
        ItemCostManagement: Codeunit 5804;
        //       Item2@7001101 :
        Item2: Record 27;
        //       Num@7001100 :
        Num: Text[20];
        //       LocationCaption@7001125 :
        LocationCaption: TextConst ENU = 'Location', ESP = 'Almac‚n';
        //       CurrReport_PAGENOCaption@7001124 :
        CurrReport_PAGENOCaption: TextConst ENU = 'Page', ESP = 'P g.';
        //       ItemCaption@7001123 :
        ItemCaption: TextConst ENU = 'Item', ESP = 'Producto';
        //       PreviousStockCaption@7001122 :
        PreviousStockCaption: TextConst ENU = 'Previous Stocks', ESP = 'Exist. Ant.';
        //       EntriesCaption@7001121 :
        EntriesCaption: TextConst ENU = 'Entries', ESP = 'Entradas';
        //       OutputsCaption@7001120 :
        OutputsCaption: TextConst ENU = 'Outputs', ESP = 'Salidas';
        //       StockperiodCaption@7001119 :
        StockperiodCaption: TextConst ENU = 'Stock Period', ESP = 'Exist. Actual';
        //       HalfpriceCaption@7001118 :
        HalfpriceCaption: TextConst ENU = 'Half Price', ESP = 'Precio medio';
        //       AssessmentCaption@7001117 :
        AssessmentCaption: TextConst ENU = 'Assessment', ESP = 'Valoraci¢n';
        //       UMCaption@7001116 :
        UMCaption: TextConst ENU = 'Unit of measure', ESP = 'U. M.';
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
        //       FirstLine@1000000000 :
        FirstLine: Boolean;
        //       ItemLedgerEntry@1100286000 :
        ItemLedgerEntry: Record 32;
        //       ItemLedgerEntry2@1100286001 :
        ItemLedgerEntry2: Record 32;
        //       OmitirValor0@1100286002 :
        OmitirValor0: Boolean;



    trigger OnPreReport();
    begin
        FirstLine := TRUE;
    end;



    /*begin
        {
          Q19460 APC 11/05/23 - Se a¤ade opci¢n para no mostrar lineas con valoraci¢n 0
        }
        end.
      */

}



// RequestFilterFields="No.","Inventory Posting Group","Gen. Prod. Posting Group";


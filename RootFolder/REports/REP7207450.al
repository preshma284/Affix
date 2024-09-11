report 7207450 "QB Items Ceded"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Items Ceded', ESP = 'Productos cedidos';

    dataset
    {

        DataItem("Job"; "Job")
        {

            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            Column(COMPANYNAME; COMPANYPROPERTY.DISPLAYNAME)
            {
                //SourceExpr=COMPANYPROPERTY.DISPLAYNAME;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(CededLbl; CededLbl)
            {
                //SourceExpr=CededLbl;
            }
            Column(JobLbl; JobLbl)
            {
                //SourceExpr=JobLbl;
            }
            Column(DateLbl; DateLbl)
            {
                //SourceExpr=DateLbl;
            }
            Column(QtyLbl; QtyLbl)
            {
                //SourceExpr=QtyLbl;
            }
            Column(UDLbl; UDLbl)
            {
                //SourceExpr=UDLbl;
            }
            Column(TypeLbl; TypeLbl)
            {
                //SourceExpr=TypeLbl;
            }
            Column(DocNoLbl; DocNoLbl)
            {
                //SourceExpr=DocNoLbl;
            }
            Column(CodeLbl; CodeLbl)
            {
                //SourceExpr=CodeLbl;
            }
            Column(DescriptionLbl; DescriptionLbl)
            {
                //SourceExpr=DescriptionLbl;
            }
            Column(TotalLbl; TotalLbl)
            {
                //SourceExpr=TotalLbl;
            }
            Column(LocationLbl; LocationLbl)
            {
                //SourceExpr=LocationLbl;
            }
            Column(UnitCostLbl; UnitCostLbl)
            {
                //SourceExpr=UnitCostLbl;
            }
            Column(TotalCostLbl; TotalCostLbl)
            {
                //SourceExpr=TotalCostLbl;
            }
            Column(No_Job; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            Column(Description_Job; Job.Description)
            {
                //SourceExpr=Job.Description;
            }
            DataItem("Item"; "Item")
            {

                DataItemTableView = WHERE("QB Plant Item" = CONST(true));
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.";
                Column(No_Item; Item."No.")
                {
                    //SourceExpr=Item."No.";
                }
                Column(Description_Item; Item.Description)
                {
                    //SourceExpr=Item.Description;
                }
                DataItem("QB Posted Receipt/Trans.Lines"; "QB Posted Receipt/Trans.Lines")
                {

                    DataItemTableView = SORTING("Document No.", "Line No.")
                                 ORDER(Ascending);
                    DataItemLink = "Item No." = FIELD("No.");
                    Column(No_PostedReceiptTransferHeader; PostedReceiptTransferHeader."No.")
                    {
                        //SourceExpr=PostedReceiptTransferHeader."No.";
                    }
                    Column(Date_PostedReceiptTransferHeader; PostedReceiptTransferHeader."Posting Date")
                    {
                        //SourceExpr=PostedReceiptTransferHeader."Posting Date";
                    }
                    Column(LineNo_PostedReceiptTransferLine; "QB Posted Receipt/Trans.Lines"."Line No.")
                    {
                        //SourceExpr="QB Posted Receipt/Trans.Lines"."Line No.";
                    }
                    Column(Quantity_PostedReceiptTransferLine; "QB Posted Receipt/Trans.Lines".Quantity)
                    {
                        //SourceExpr="QB Posted Receipt/Trans.Lines".Quantity;
                    }
                    Column(UnitofMeasureCode_PostedReceiptTransferLine; "QB Posted Receipt/Trans.Lines"."Unit of Measure Code")
                    {
                        //SourceExpr="QB Posted Receipt/Trans.Lines"."Unit of Measure Code";
                    }
                    Column(UnitCost_PostedReceiptTransferLine; "QB Posted Receipt/Trans.Lines"."Unit Cost")
                    {
                        //SourceExpr="QB Posted Receipt/Trans.Lines"."Unit Cost";
                    }
                    Column(TotalCost_PostedReceiptTransferLine; "QB Posted Receipt/Trans.Lines"."Total Cost")
                    {
                        //SourceExpr="QB Posted Receipt/Trans.Lines"."Total Cost";
                    }
                    Column(OriginLocation_PostedReceiptTransferLine; "QB Posted Receipt/Trans.Lines"."Origin Location")
                    {
                        //SourceExpr="QB Posted Receipt/Trans.Lines"."Origin Location";
                    }
                    Column(ReceiptTxt; ReceiptTxt)
                    {
                        //SourceExpr=ReceiptTxt;
                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        "QB Posted Receipt/Trans.Lines".SETRANGE("Document Job No.", Job."No.");
                        "QB Posted Receipt/Trans.Lines".SETRANGE("Document Type", "QB Posted Receipt/Trans.Lines"."Document Type"::Receipt);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        PostedReceiptTransferHeader.GET("QB Posted Receipt/Trans.Lines"."Document No.");

                        IF FromDate <> 0D THEN
                            IF PostedReceiptTransferHeader."Posting Date" < FromDate THEN
                                CurrReport.SKIP;

                        IF ToDate <> 0D THEN
                            IF PostedReceiptTransferHeader."Posting Date" > ToDate THEN
                                CurrReport.SKIP;
                    END;
                }
                DataItem("Posted Output Shipment Lines"; "Posted Output Shipment Lines")
                {

                    DataItemTableView = SORTING("Document No.", "Line No.")
                                 ORDER(Ascending);
                    DataItemLink = "No." = FIELD("No.");
                    Column(No_PostedOutputShipmentHeader; PostedOutputShipmentHeader."No.")
                    {
                        //SourceExpr=PostedOutputShipmentHeader."No.";
                    }
                    Column(Date_PostedOutputShipmentHeader; PostedOutputShipmentHeader."Posting Date")
                    {
                        //SourceExpr=PostedOutputShipmentHeader."Posting Date";
                    }
                    Column(LineNo_PostedOutputShipmentLines; "Posted Output Shipment Lines"."Line No.")
                    {
                        //SourceExpr="Posted Output Shipment Lines"."Line No.";
                    }
                    Column(Quantity_PostedOutputShipmentLines; -1 * "Posted Output Shipment Lines".Quantity)
                    {
                        //SourceExpr=-1*"Posted Output Shipment Lines".Quantity;
                    }
                    Column(UnitofMeasureCode_PostedOutputShipmentLines; "Posted Output Shipment Lines"."Unit of Measure Code")
                    {
                        //SourceExpr="Posted Output Shipment Lines"."Unit of Measure Code";
                    }
                    Column(UnitCost_PostedOutputShipmentLines; "Posted Output Shipment Lines"."Unit Cost")
                    {
                        //SourceExpr="Posted Output Shipment Lines"."Unit Cost";
                    }
                    Column(OutboundWarehouse_PostedOutputShipmentLines; "Posted Output Shipment Lines"."Outbound Warehouse")
                    {
                        //SourceExpr="Posted Output Shipment Lines"."Outbound Warehouse";
                    }
                    Column(TotalCost_PostedOutputShipmentLines; "Posted Output Shipment Lines"."Total Cost")
                    {
                        //SourceExpr="Posted Output Shipment Lines"."Total Cost";
                    }
                    Column(OutpostTxt; OutpostTxt)
                    {
                        //SourceExpr=OutpostTxt ;
                    }
                    //D3 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        "Posted Output Shipment Lines".SETRANGE("Job No.", Job."No.");
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        PostedOutputShipmentHeader.GET("Posted Output Shipment Lines"."Document No.");

                        IF FromDate <> 0D THEN
                            IF PostedOutputShipmentHeader."Posting Date" < FromDate THEN
                                CurrReport.SKIP;

                        IF ToDate <> 0D THEN
                            IF PostedOutputShipmentHeader."Posting Date" > ToDate THEN
                                CurrReport.SKIP;
                    END;


                }
                //D1 Triggers
            }
            //Job Triggers
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group952")
                {

                    CaptionML = ENU = 'FILTER', ESP = 'Filtros';
                    field("FromDate"; "FromDate")
                    {

                        CaptionML = ENU = 'From Date', ESP = 'Fecha desde';
                    }
                    field("ToDate"; "ToDate")
                    {

                        CaptionML = ENU = 'To Date', ESP = 'Fecha hasta';
                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            Item.SETRANGE("No.", ItemNoFilter);
        END;


    }
    labels
    {
    }

    var
        //       PostedReceiptTransferHeader@1100286000 :
        PostedReceiptTransferHeader: Record 7206972;
        //       PostedOutputShipmentHeader@1100286001 :
        PostedOutputShipmentHeader: Record 7207310;
        //       CurrReport_PAGENOCaptionLbl@1100286008 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       CededLbl@1100286004 :
        CededLbl: TextConst ENU = 'Ceded', ESP = 'Cedidos';
        //       JobLbl@1100286005 :
        JobLbl: TextConst ENU = 'Job No.', ESP = 'N§ proyecto';
        //       DateLbl@1100286010 :
        DateLbl: TextConst ENU = 'Date', ESP = 'Fecha';
        //       QtyLbl@1100286011 :
        QtyLbl: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       UDLbl@1100286012 :
        UDLbl: TextConst ENU = 'UOM', ESP = 'Ud. de medida';
        //       TypeLbl@1100286013 :
        TypeLbl: TextConst ENU = 'Type', ESP = 'Tipo';
        //       DocNoLbl@1100286014 :
        DocNoLbl: TextConst ENU = 'Document No.', ESP = 'N§ documento';
        //       CodeLbl@1100286006 :
        CodeLbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       DescriptionLbl@1100286007 :
        DescriptionLbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       ReceiptTxt@1100286002 :
        ReceiptTxt: TextConst ENU = 'Receipt', ESP = 'Recepci¢n';
        //       OutpostTxt@1100286003 :
        OutpostTxt: TextConst ENU = 'Outpost', ESP = 'Salida';
        //       TotalLbl@1100286009 :
        TotalLbl: TextConst ENU = 'Total', ESP = 'Total';
        //       FromDate@1100286016 :
        FromDate: Date;
        //       ToDate@1100286015 :
        ToDate: Date;
        //       ItemNoFilter@1100286017 :
        ItemNoFilter: Code[20];
        //       LocationLbl@1100286018 :
        LocationLbl: TextConst ENU = 'Location', ESP = 'Almac‚n';
        //       UnitCostLbl@1100286019 :
        UnitCostLbl: TextConst ENU = 'Unit Cost', ESP = 'Coste unitario';
        //       TotalCostLbl@1100286020 :
        TotalCostLbl: TextConst ENU = 'Total Cost', ESP = 'Coste total';

    //     procedure SetItemNo (ItemNoFilterAux@1100286000 :
    procedure SetItemNo(ItemNoFilterAux: Code[20])
    begin
        ItemNoFilter := ItemNoFilterAux;
    end;

    /*begin
    end.
  */

}



// RequestFilterFields="No.";


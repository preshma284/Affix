report 7207446 "QB Exp./Inv. Service Order"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Exp./Inv. Canal Service Order', ESP = 'Ventas/Costes pedidos servicio';

    dataset
    {

        DataItem("QB Service Order Header"; "QB Service Order Header")
        {

            DataItemTableView = SORTING("No.")
                                 ORDER(Ascending);


            RequestFilterFields = "Job No.", "Grouping Criteria", "Service Date";
            Column(ServiceOrderTypesLbl; Label)
            {
                //SourceExpr=Label;
            }
            Column(COMPANYNAME; COMPANYPROPERTY.DISPLAYNAME)
            {
                //SourceExpr=COMPANYPROPERTY.DISPLAYNAME;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(Filters; Filters)
            {
                //SourceExpr=Filters;
            }
            Column(No_MeasurementHeader; "QB Service Order Header"."No.")
            {
                //SourceExpr="QB Service Order Header"."No.";
            }
            Column(Description_MeasurementHeader; "QB Service Order Header"."Job Description")
            {
                //SourceExpr="QB Service Order Header"."Job Description";
            }
            Column(NoMeasure_MeasurementHeader; '***')
            {
                //SourceExpr='***';
            }
            Column(CustomerNo_MeasurementHeader; "QB Service Order Header"."Customer No.")
            {
                //SourceExpr="QB Service Order Header"."Customer No.";
            }
            Column(Name_MeasurementHeader; "QB Service Order Header".Name)
            {
                //SourceExpr="QB Service Order Header".Name;
            }
            Column(ExpensesInvestment_MeasurementHeader; "QB Service Order Header"."Expenses/Investment")
            {
                //SourceExpr="QB Service Order Header"."Expenses/Investment";
            }
            Column(ServiceOrderType_MeasurementHeader; "QB Service Order Header"."Service Order Type")
            {
                //SourceExpr="QB Service Order Header"."Service Order Type";
            }
            Column(ShiptoCode_MeasurementHeader; "QB Service Order Header"."Ship-to City")
            {
                //SourceExpr="QB Service Order Header"."Ship-to City";
            }
            Column(ShiptoAddress; "QB Service Order Header"."Ship-to Address" + ' ' + "QB Service Order Header"."Ship-to Address 2")
            {
                //SourceExpr="QB Service Order Header"."Ship-to Address" +' ' +"QB Service Order Header"."Ship-to Address 2";
            }
            Column(MeasurementDate_MeasurementHeader; "QB Service Order Header"."Service Date")
            {
                //SourceExpr="QB Service Order Header"."Service Date";
            }
            Column(ServiceOrderTypeName; ServiceOrderTypeName)
            {
                //SourceExpr=ServiceOrderTypeName;
            }
            Column(ExecutionPrice; ExecutionPrice)
            {
                //SourceExpr=ExecutionPrice;
            }
            Column(AdjudicationPrice; AdjudicationPrice)
            {
                //SourceExpr=AdjudicationPrice;
            }
            Column(ServiceTypeLbl; ServiceTypeLbl)
            {
                //SourceExpr=ServiceTypeLbl;
            }
            Column(ServiceOrderLbl; ServiceOrderLbl)
            {
                //SourceExpr=ServiceOrderLbl;
            }
            Column(CustomerLbl; CustomerLbl)
            {
                //SourceExpr=CustomerLbl;
            }
            Column(CityLbl; CityLbl)
            {
                //SourceExpr=CityLbl;
            }
            Column(DescriptionLbl; DescriptionLbl)
            {
                //SourceExpr=DescriptionLbl;
            }
            Column(ExecutionPriceLbl; ExecutionPriceLbl)
            {
                //SourceExpr=ExecutionPriceLbl;
            }
            Column(AdjudicationPriceLbl; AdjudicationPriceLbl)
            {
                //SourceExpr=AdjudicationPriceLbl;
            }
            Column(TotalLbl; TotalLbl)
            {
                //SourceExpr=TotalLbl;
            }
            Column(AddressLbl; AddressLbl)
            {
                //SourceExpr=AddressLbl;
            }
            Column(GroupingCriteriaLbl; GroupingCriteriaLbl)
            {
                //SourceExpr=GroupingCriteriaLbl;
            }
            Column(GroupingCriteria_MeasurementHeader; "QB Service Order Header"."Grouping Criteria")
            {
                //SourceExpr="QB Service Order Header"."Grouping Criteria";
            }
            Column(ServiceDateLbl; ServiceDateLbl)
            {
                //SourceExpr=ServiceDateLbl;
            }
            Column(AreaLbl; AreaLbl)
            {
                //SourceExpr=AreaLbl;
            }
            Column(MonthLbl; MonthLbl)
            {
                //SourceExpr=MonthLbl;
            }
            Column(ContractorLbl; ContractorLbl)
            {
                //SourceExpr=ContractorLbl;
            }
            Column(ClasificationLbl; ClasificationLbl)
            {
                //SourceExpr=ClasificationLbl;
            }
            Column(AreaTxt; AreaTxt)
            {
                //SourceExpr=AreaTxt;
            }
            Column(MonthTxt; MonthTxt)
            {
                //SourceExpr=MonthTxt;
            }
            Column(ContrataTxt; ContrataTxt)
            {
                //SourceExpr=ContrataTxt;
            }
            Column(ClasificacionTxt; ClasificacionTxt)
            {
                //SourceExpr=ClasificacionTxt;
            }
            Column(RevPricesIPCLbl; RevPricesIPCLbl)
            {
                //SourceExpr=RevPricesIPCLbl;
            }
            Column(AmountIPCPercentage; AmountIPCPercentage)
            {
                //SourceExpr=AmountIPCPercentage;
            }
            Column(IPCPercentage; FORMAT(IPCPercentage) + ' %')
            {
                //SourceExpr=FORMAT(IPCPercentage) + ' %';
            }
            Column(RevPricesIPCAmountLbl; RevPricesIPCAmountLbl)
            {
                //SourceExpr=RevPricesIPCAmountLbl;
            }
            Column(AmountIPCPercentageTotal; AmountIPCPercentageTotal)
            {
                //SourceExpr=AmountIPCPercentageTotal;
            }
            Column(PricesWithIPCLbl; PricesWithIPCLbl)
            {
                //SourceExpr=PricesWithIPCLbl;
            }
            Column(opcIPC; opcIPC)
            {
                //SourceExpr=opcIPC;
            }
            Column(ExtServiceOrder; "QB Service Order Header"."Ext order service")
            {
                //SourceExpr="QB Service Order Header"."Ext order service" ;
            }
            trigger OnAfterGetRecord();
            BEGIN
                ExecutionPrice := 0;
                AdjudicationPrice := 0;

                MeasurementLines.RESET;
                MeasurementLines.SETRANGE("Document No.", "QB Service Order Header"."No.");
                IF MeasurementLines.FINDSET THEN BEGIN
                    REPEAT
                        ExecutionPrice += MeasurementLines."Cost Amount";
                        AdjudicationPrice += MeasurementLines."Sale Amount";
                    UNTIL MeasurementLines.NEXT = 0;
                END;

                ServiceOrderTypeName := '';
                IF ServiceOrderType.GET("QB Service Order Header"."Service Order Type") THEN
                    ServiceOrderTypeName := ServiceOrderType.Description;

                //Q12733 -
                IPCPercentage := "QB Service Order Header"."Price review percentage";

                //Q12733 MOD01 -
                //IF AdjudicationPrice <> 0 THEN
                IF IPCPercentage <> 0 THEN BEGIN
                    AmountIPCPercentage := ROUND(AdjudicationPrice * IPCPercentage / 100);
                    AmountIPCPercentageTotal += ROUND(AdjudicationPrice * IPCPercentage / 100);
                    //Q12733 MOD01 +
                END ELSE BEGIN
                    AmountIPCPercentage := 0;
                    AmountIPCPercentageTotal += 0;
                END;
                //Q12733 +
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("Filters")
                {

                    CaptionML = ENU = 'Filters', ESP = 'Filtros';
                    field("AreaTxt"; "AreaTxt")
                    {

                        CaptionML = ENU = 'Area', ESP = 'Area';
                    }
                    field("MonthTxt"; "MonthTxt")
                    {

                        CaptionML = ENU = 'Month', ESP = 'Mes';
                    }
                    field("ContrataTxt"; "ContrataTxt")
                    {

                        CaptionML = ENU = 'Contractor', ESP = 'Contrata';
                    }
                    field("ClasificacionTxt"; "ClasificacionTxt")
                    {

                        CaptionML = ENU = 'Clasification', ESP = 'Clasificaci¢n';
                    }
                    field("opcIPC"; "opcIPC")
                    {

                        CaptionML = ESP = 'false incluir I.P.C.';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       MeasurementLines@1100286000 :
        MeasurementLines: Record 7206967;
        //       ExecutionPrice@1100286001 :
        ExecutionPrice: Decimal;
        //       AdjudicationPrice@1100286002 :
        AdjudicationPrice: Decimal;
        //       Label@1100286016 :
        Label: TextConst ENU = 'Exp./Inv. Canal Service Order', ESP = 'Ventas/Costes pedidos servicio';
        //       CurrReport_PAGENOCaptionLbl@1100286015 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       CodeLbl@1100286014 :
        CodeLbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       DescriptionLbl@1100286012 :
        DescriptionLbl: TextConst ENU = 'Descripiton', ESP = 'Descripci¢n';
        //       ExecutionPriceLbl@1100286010 :
        ExecutionPriceLbl: TextConst ENU = 'Execution Price', ESP = 'Precio ejecuci¢n';
        //       AdjudicationPriceLbl@1100286009 :
        AdjudicationPriceLbl: TextConst ENU = 'Adjudication Price', ESP = 'Precio adjudicaci¢n';
        //       ServiceTypeLbl@1100286004 :
        ServiceTypeLbl: TextConst ENU = 'Service Type', ESP = 'Tipo servicio';
        //       ServiceOrderLbl@1100286013 :
        ServiceOrderLbl: TextConst ENU = 'Service Order', ESP = 'Pedido servicio';
        //       CustomerLbl@1100286005 :
        CustomerLbl: TextConst ENU = 'Customer', ESP = 'Cliente';
        //       CityLbl@1100286011 :
        CityLbl: TextConst ENU = 'City', ESP = 'Ciudad';
        //       TotalLbl@1100286003 :
        TotalLbl: TextConst ENU = 'Total', ESP = 'Total';
        //       Filters@1100286007 :
        Filters: Text;
        //       AddressLbl@1100286006 :
        AddressLbl: TextConst ENU = 'Address', ESP = 'Direcci¢n';
        //       GroupingCriteriaLbl@100000000 :
        GroupingCriteriaLbl: TextConst ENU = 'Grouping Criteria', ESP = 'Criterio agrupaci¢n';
        //       ServiceDateLbl@1100286008 :
        ServiceDateLbl: TextConst ENU = 'Service Date', ESP = 'Fecha servicio';
        //       Filters2@1100286021 :
        Filters2: Text;
        //       AreaLbl@1100286022 :
        AreaLbl: TextConst ENU = 'Area:', ESP = 'Area:';
        //       MonthLbl@1100286023 :
        MonthLbl: TextConst ENU = 'Month:', ESP = 'Mes:';
        //       ContractorLbl@1100286024 :
        ContractorLbl: TextConst ENU = 'Contractor:', ESP = 'Contrata:';
        //       ClasificationLbl@1100286025 :
        ClasificationLbl: TextConst ENU = 'Clasification:', ESP = 'Clasificaci¢n:';
        //       ServiceOrderType@1100286026 :
        ServiceOrderType: Record 7206974;
        //       ServiceOrderTypeName@1100286027 :
        ServiceOrderTypeName: Text;
        //       RevPricesIPCLbl@100000001 :
        RevPricesIPCLbl: TextConst ENU = 'IPC', ESP = 'IPC';
        //       AmountIPCPercentage@100000003 :
        AmountIPCPercentage: Decimal;
        //       IPCPercentage@100000002 :
        IPCPercentage: Decimal;
        //       RevPricesIPCAmountLbl@100000004 :
        RevPricesIPCAmountLbl: TextConst ENU = 'IPC Amount', ESP = 'Importe IPC';
        //       AmountIPCPercentageTotal@100000005 :
        AmountIPCPercentageTotal: Decimal;
        //       PricesWithIPCLbl@100000006 :
        PricesWithIPCLbl: TextConst ENU = 'Adjudication Price + IPC', ESP = 'Precio adjudicaci¢n + IPC';
        //       "------------------------------------ Opciones"@1100286017 :
        "------------------------------------ Opciones": Integer;
        //       AreaTxt@1100286028 :
        AreaTxt: Text;
        //       MonthTxt@1100286020 :
        MonthTxt: Text;
        //       ContrataTxt@1100286019 :
        ContrataTxt: Text;
        //       ClasificacionTxt@1100286018 :
        ClasificacionTxt: Text;
        //       opcIPC@1100286029 :
        opcIPC: Boolean;



    trigger OnPreReport();
    var
        //                   CaptionManagement@1100286000 :
        CaptionManagement: Codeunit 42;
        CaptionManagement2: Codeunit "CaptionManagement";
                begin
        Filters := CaptionManagement2.GetRecordFiltersWithCaptions("QB Service Order Header");
        Filters2 := AreaTxt + ' - ' + MonthTxt + ' - ' + ContrataTxt + ' - ' + ClasificacionTxt;
    end;



    /*begin
        {
          Q5874

          Q12733 HAN 26/03/21: Added new IPC Percentage amount to the report
          Q12733 MOD01 05/04/21: Correct calculations
          Q13210 HAN 16/04/21: Added new IPC totals in layout
          Q13210.01 PSM 22/04/21: Added new Price+IPC column in layout
          Q16330 EPV 11/02/22 : Mostraba s¢lo la primera cabecera de pedidos de servicio debido a que estaba mal la propiedad "Group on" de la l¡nea de detalle
          INESCO EPV 23/02/22 : Se pide que ordene el listado por el campo "n§ de pedido externo"
        }
        end.
      */

}





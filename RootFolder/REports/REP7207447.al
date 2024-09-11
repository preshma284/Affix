report 7207447 "QB Evaluation Breakdown List"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Evaluation Breakdown List', ESP = 'Lista valoraciones desglosado';

    dataset
    {

        DataItem("QB Service Order Header"; "QB Service Order Header")
        {

            DataItemTableView = SORTING("Expenses/Investment", "Service Order Type")
                                 ORDER(Ascending);


            RequestFilterFields = "Job No.", "Status", "Posting Date";
            Column(No_MeasurementHeader; "QB Service Order Header"."No.")
            {
                //SourceExpr="QB Service Order Header"."No.";
            }
            Column(MeasurementDate_MeasurementHeader; "QB Service Order Header"."Service Date")
            {
                //SourceExpr="QB Service Order Header"."Service Date";
            }
            Column(NoMeasure_MeasurementHeader; "QB Service Order Header"."No.")
            {
                //SourceExpr="QB Service Order Header"."No.";
            }
            Column(ExpensesInvestment_MeasurementHeader; "QB Service Order Header"."Expenses/Investment")
            {
                //SourceExpr="QB Service Order Header"."Expenses/Investment";
            }
            Column(ServiceOrderType_MeasurementHeader; "QB Service Order Header"."Service Order Type")
            {
                //SourceExpr="QB Service Order Header"."Service Order Type";
            }
            Column(ExtOrderService; "QB Service Order Header"."Ext order service")
            {
                //SourceExpr="QB Service Order Header"."Ext order service";
            }
            Column(ServiceOrderTypeText_MeasurementHeader; ServiceOrderTypeText)
            {
                //SourceExpr=ServiceOrderTypeText;
            }
            Column(Status_MeasurementHeader; "QB Service Order Header".Status)
            {
                //SourceExpr="QB Service Order Header".Status;
            }
            Column(MeasurementService_MeasurementHeader; '')
            {
                //SourceExpr='';
            }
            Column(ShiptoCode_MeasurementHeader; "QB Service Order Header"."Ship-to Code")
            {
                //SourceExpr="QB Service Order Header"."Ship-to Code";
            }
            Column(ShiptoAddress_MeasurementHeader; "QB Service Order Header"."Ship-to Address" + ' ' + "QB Service Order Header"."Ship-to Address 2")
            {
                //SourceExpr="QB Service Order Header"."Ship-to Address"+' ' +"QB Service Order Header"."Ship-to Address 2";
            }
            Column(ShiptoCity_MeasurementHeader; "QB Service Order Header"."Ship-to City")
            {
                //SourceExpr="QB Service Order Header"."Ship-to City";
            }
            Column(Result_MeasurementHeader; Result)
            {
                //SourceExpr=Result;
            }
            Column(ServiceTypeLbl; ServiceTypeLbl)
            {
                //SourceExpr=ServiceTypeLbl;
            }
            Column(ServiceOrderLbl; ServiceOrderLbl)
            {
                //SourceExpr=ServiceOrderLbl;
            }
            Column(AdressLbl; AdressLbl)
            {
                //SourceExpr=AdressLbl;
            }
            Column(CityLbl; CityLbl)
            {
                //SourceExpr=CityLbl;
            }
            Column(DateLbl; DateLbl)
            {
                //SourceExpr=DateLbl;
            }
            Column(ResultLbl; ResultLbl)
            {
                //SourceExpr=ResultLbl;
            }
            Column(DescriptionLbl; DescriptionLbl)
            {
                //SourceExpr=DescriptionLbl;
            }
            Column(QytLbl; QytLbl)
            {
                //SourceExpr=QytLbl;
            }
            Column(PriceLbl; PriceLbl)
            {
                //SourceExpr=PriceLbl;
            }
            Column(SubtotalLbl; SubtotalLbl)
            {
                //SourceExpr=SubtotalLbl;
            }
            Column(BaseLbl; BaseLbl)
            {
                //SourceExpr=BaseLbl;
            }
            Column(TotalLbl; TotalLbl)
            {
                //SourceExpr=TotalLbl;
            }
            Column(SumaBase; SumaBase)
            {
                //SourceExpr=SumaBase;
            }
            DataItem("QB Service Order Lines"; "QB Service Order Lines")
            {
                // verify similar scenarios
                DataItemTableView = SORTING("Document No.", "Line No.")
                                 ORDER(Ascending);
                DataItemLink = "Document No." = FIELD("No.");
                Column(DocumentNo_MeasurementLines; "QB Service Order Lines"."Document No.")
                {
                    //SourceExpr="QB Service Order Lines"."Document No.";
                }
                Column(LineNo_MeasurementLines; "QB Service Order Lines"."Line No.")
                {
                    //SourceExpr="QB Service Order Lines"."Line No.";
                }
                Column(PieceworkNo_MeasurementLines; "QB Service Order Lines"."Code Piecework PRESTO")
                {
                    //SourceExpr="QB Service Order Lines"."Code Piecework PRESTO";
                }
                Column(Description_MeasurementLines; LongDesc)
                {
                    //SourceExpr=LongDesc;
                }
                Column(UOM_MeasurementLines; UOM)
                {
                    //SourceExpr=UOM;
                }
                Column(Qty_MeasurementLines; Qty)
                {
                    //SourceExpr=Qty;
                }
                Column(Amount_MeasurementLines; "QB Service Order Lines"."Contract Price")
                {
                    //SourceExpr="QB Service Order Lines"."Contract Price";
                }
                Column(ExecutionPrice_MeasurementLines; "QB Service Order Lines"."Cost Amount")
                {
                    //SourceExpr="QB Service Order Lines"."Cost Amount";
                }
                Column(AdjudicationPrice_MeasurementLines; "QB Service Order Lines"."Sale Amount")
                {
                    //SourceExpr="QB Service Order Lines"."Sale Amount";
                }
                Column(PieceworkDescription; "QB Service Order Lines".Description)
                {
                    //SourceExpr="QB Service Order Lines".Description ;
                }
                trigger OnAfterGetRecord();
                VAR
                    //                                   rText@1100286000 :
                    rText: Record 7206918;
                BEGIN

                    DataPieceworkForProduction.GET("QB Service Order Header"."Job No.", "QB Service Order Lines"."Piecework No.");
                    UOM := DataPieceworkForProduction."Unit Of Measure";

                    LongDesc := '';
                    // CEI (EPV) 24/02/22 Uso de funcionalidad de "Textos extendidos"
                    CLEAR(rText);
                    IF rText.GET(rText.Table::Job, "QB Service Order Lines"."Job No.", "QB Service Order Lines"."Piecework No.", '') THEN BEGIN
                        LongDesc := rText.GetCostText;
                    END;
                    //{SE COMENTA. NO EXISTE OPCION "Piecework Job Costs" EN LA TABLA 280 Extended Text Line
                    //                                  ExtendedTextLine.RESET;
                    //                                  ExtendedTextLine.SETRANGE("Table Name", ExtendedTextLine."Table Name"::"Piecework Job Costs");
                    //                                  ExtendedTextLine.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
                    //                                  ExtendedTextLine.SETRANGE("Text No.", 1);
                    //                                  IF ExtendedTextLine.FINDSET THEN BEGIN 
                    //                                    REPEAT
                    //                                      LongDesc += ExtendedTextLine.Text + ' ';
                    //                                    UNTIL ExtendedTextLine.NEXT = 0;
                    //                                    LongDesc := COPYSTR(LongDesc, 1, STRLEN(LongDesc)-1);
                    //                                  END;
                    //                                  }
                    Qty := "QB Service Order Lines".Quantity;
                    SumaBase += "QB Service Order Lines"."Sale Amount";
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                ServiceOrderTypeText := "QB Service Order Header"."Service Order Type";
                IF ServiceOrderType.GET("QB Service Order Header"."Service Order Type") THEN
                    ServiceOrderTypeText += '. ' + ServiceOrderType.Description;

                Result := "QB Service Order Header".GetOperationResult;

                SumaBase := 0;
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
    }

    var
        //       ServiceTypeLbl@1100286000 :
        ServiceTypeLbl: TextConst ENU = 'SERVICE TYPE', ESP = 'TIPO SERVICIO';
        //       ServiceOrderLbl@1100286001 :
        ServiceOrderLbl: TextConst ENU = 'Service Order', ESP = 'Pedido servicio';
        //       AdressLbl@1100286004 :
        AdressLbl: TextConst ENU = 'Address', ESP = 'Direcci¢n';
        //       CityLbl@1100286005 :
        CityLbl: TextConst ENU = 'City', ESP = 'Municipio';
        //       DateLbl@1100286006 :
        DateLbl: TextConst ENU = 'Date', ESP = 'Fecha';
        //       ResultLbl@1100286014 :
        ResultLbl: TextConst ENU = 'RESULT', ESP = 'RESULTADO';
        //       DescriptionLbl@1100286007 :
        DescriptionLbl: TextConst ENU = 'DSCRIPTION', ESP = 'DESCRIPCI‡N';
        //       QytLbl@1100286008 :
        QytLbl: TextConst ENU = 'QUANTITY', ESP = 'UNIDADES';
        //       PriceLbl@1100286009 :
        PriceLbl: TextConst ENU = 'PRICE', ESP = 'PRECIO COSTE';
        //       SubtotalLbl@1100286010 :
        SubtotalLbl: TextConst ENU = 'SUBTOTAL', ESP = 'TOTAL COSTE';
        //       BaseLbl@1100286011 :
        BaseLbl: TextConst ENU = 'BASE', ESP = 'TOTAL VENTA';
        //       TotalLbl@1100286012 :
        TotalLbl: TextConst ENU = 'Order Total', ESP = 'Total pedido';
        //       ServiceOrderType@1100286019 :
        ServiceOrderType: Record 7206974;
        //       ServiceOrderTypeText@1100286018 :
        ServiceOrderTypeText: Text;
        //       Result@1100286016 :
        Result: Text;
        //       DataPieceworkForProduction@1100286003 :
        DataPieceworkForProduction: Record 7207386;
        //       Qty@1100286013 :
        Qty: Decimal;
        //       UOM@1100286002 :
        UOM: Text;
        //       LongDesc@1100286015 :
        LongDesc: Text;
        //       ExtendedTextLine@1100286017 :
        ExtendedTextLine: Record 280;
        //       SumaBase@100000000 :
        SumaBase: Decimal;

    /*begin
    {
      Q16212 - 01/02/22 (MRV) -Se ha modificado el layout con el campo nuevo de pedido de servicio y
                se corrigio la descripcion de la partida que no se mostraba en el informe

      CEI (EPV) 24/02/22 Uso de funcionalidad de "Textos extendidos"

      INESCO (EPV) 02/03/22 : Se pide que ordene el listado por el campo "nß de pedido externo"
    }
    end.
  */

}





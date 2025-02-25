report 7207405 "Albar n Compra"
{


    ;
    dataset
    {

        DataItem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            Column(AlbaranNo_Caption; AlbaranNo_CaptionLbl)
            {
                //SourceExpr=Albar nNo_CaptionLbl;
            }
            Column(FechaPedido_Caption; FechaPedido_CaptionLbl)
            {
                //SourceExpr=FechaPedido_CaptionLbl;
            }
            Column(Proveedor_Caption; Proveedor_CaptionLbl)
            {
                //SourceExpr=Proveedor_CaptionLbl;
            }
            Column(FechaEntrega_Caption; FechaEntrega_CaptionLbl)
            {
                //SourceExpr=FechaEntrega_CaptionLbl;
            }
            Column(Direccion_Caption; Direccion_CaptionLbl)
            {
                //SourceExpr=Direccion_CaptionLbl;
            }
            Column(Poblacion_Caption; Poblacion_CaptionLbl)
            {
                //SourceExpr=Poblacion_CaptionLbl;
            }
            Column(OP_Caption; OP_CaptionLbl)
            {
                //SourceExpr=OP_CaptionLbl;
            }
            DataItem("CopyLoop"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                ;
                DataItem("PageLoop"; "2000000026")
                {

                    DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                    Column(No_PurchRcptHeader; "Purch. Rcpt. Header"."No.")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."No.";
                    }
                    Column(OrderDate_PurchRcptHeader; "Purch. Rcpt. Header"."Order Date")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Order Date";
                    }
                    Column(PostingDate_PurchRcptHeader; "Purch. Rcpt. Header"."Posting Date")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Posting Date";
                    }
                    Column(VendorName_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor Name")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Buy-from Vendor Name";
                    }
                    Column(VendorName2_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor Name 2")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Buy-from Vendor Name 2";
                    }
                    Column(City_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from City")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Buy-from City";
                    }
                    Column(PostCode_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Post Code")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Buy-from Post Code";
                    }
                    Column(Address_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Address")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Buy-from Address";
                    }
                    Column(Address2_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Address 2")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Buy-from Address 2";
                    }
                    Column(VendorOrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Vendor Order No.")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Vendor Order No.";
                    }
                    Column(OutputNo; OutputNo)
                    {
                        //SourceExpr=OutputNo;
                    }
                    Column(SumaLineas; SumaLineas)
                    {
                        //SourceExpr=SumaLineas;
                    }
                    Column(ImporteIVA; importeIVA)
                    {
                        //SourceExpr=importeIVA;
                    }
                    Column(VAT_PurchRcptLine; "Purch. Rcpt. Line"."VAT %")
                    {
                        //SourceExpr="Purch. Rcpt. Line"."VAT %";
                    }
                    Column(DirectunitCost_PurchRcptLine; "Purch. Rcpt. Line"."Direct Unit Cost")
                    {
                        //SourceExpr="Purch. Rcpt. Line"."Direct Unit Cost";
                    }
                    Column(ImporteTotal; ImporteTotal)
                    {
                        //SourceExpr=ImporteTotal;
                    }
                    DataItem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                    {

                        DataItemTableView = SORTING("Document No.", "Line No.");
                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemLink = "Document No." = FIELD("No.");
                        Column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
                        {
                            //SourceExpr="Purch. Rcpt. Line".Quantity;
                        }
                        Column(Description_PurchRcptLine; "Purch. Rcpt. Line".Description)
                        {
                            //SourceExpr="Purch. Rcpt. Line".Description;
                        }
                        Column(Description2_PurchRcptLine; "Purch. Rcpt. Line"."Description 2")
                        {
                            //SourceExpr="Purch. Rcpt. Line"."Description 2";
                        }
                        Column(UnitofMeasure_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure")
                        {
                            //SourceExpr="Purch. Rcpt. Line"."Unit of Measure";
                        }
                        Column(UnitofMeasureCode_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure Code")
                        {
                            //SourceExpr="Purch. Rcpt. Line"."Unit of Measure Code";
                        }
                        Column(Can_Caption; Can_CaptionLbl)
                        {
                            //SourceExpr=Can_CaptionLbl;
                        }
                        Column(Ud_Caption; Ud_CaptionLbl)
                        {
                            //SourceExpr=Ud_CaptionLbl;
                        }
                        Column(TRealizados_Caption; TRealizados_CaptionLbl)
                        {
                            //SourceExpr=TRealizados_CaptionLbl;
                        }
                        Column(Precio_Caption; Precio_CaptionLbl)
                        {
                            //SourceExpr=Precio_CaptionLbl;
                        }
                        Column(Importe_Caption; Importe_CaptionLbl)
                        {
                            //SourceExpr=Importe_CaptionLbl;
                        }
                        Column(IVA_Caption; IVA_CaptionLbl)
                        {
                            //SourceExpr=IVA_CaptionLbl;
                        }
                        Column(TotalEjecution_Caption; TotalEjecucion_CaptionLbl)
                        {
                            //SourceExpr=TotalEjecucion_CaptionLbl;
                        }
                        Column(TotalPres_Caption; TotalPres_CaptionLbl)
                        {
                            //SourceExpr=TotalPres_CaptionLbl;
                        }
                        Column(Conforme_Caption; Conforme_CaptionLbl)
                        {
                            //SourceExpr=Conforme_CaptionLbl ;
                        }
                    }
                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    OutputNo := 1;

                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;

                    SumaLineas := 0;
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", "Purch. Rcpt. Line"."Document No.");
                    IF PurchRcptLine.FINDSET THEN
                        REPEAT
                            SumaLineas += PurchRcptLine.Quantity * PurchRcptLine."Direct Unit Cost"
                        UNTIL PurchRcptLine.NEXT = 0;

                    importeIVA := (PurchRcptLine."VAT %" * SumaLineas) / 100;
                    ImporteTotal := SumaLineas + importeIVA;
                END;

                trigger OnPostDataItem();
                BEGIN
                    IF NOT CurrReport.PREVIEW THEN
                        CODEUNIT.RUN(CODEUNIT::"Purch.Rcpt.-Printed", "Purch. Rcpt. Header");
                END;


            }
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
        //       Albar nNo_CaptionLbl@7001100 :
        AlbaranNo_CaptionLbl: TextConst ENU = 'Shipment No:', ESP = 'Albaran n§:';
        //       FechaPedido_CaptionLbl@7001101 :
        FechaPedido_CaptionLbl: TextConst ENU = 'ORDER DATE', ESP = 'FECHA DE PEDIDO';
        //       FechaEntrega_CaptionLbl@7001102 :
        FechaEntrega_CaptionLbl: TextConst ENU = 'DELIVERY DATE', ESP = 'FECHA DE ENTREGA';
        //       Proveedor_CaptionLbl@7001103 :
        Proveedor_CaptionLbl: TextConst ENU = 'Vendor:', ESP = 'Proveedor:';
        //       Direccion_CaptionLbl@7001104 :
        Direccion_CaptionLbl: TextConst ENU = 'Address:', ESP = 'Direcci¢n:';
        //       Poblacion_CaptionLbl@7001105 :
        Poblacion_CaptionLbl: TextConst ENU = 'City:', ESP = 'Poblaci¢n:';
        //       Can_CaptionLbl@7001106 :
        Can_CaptionLbl: TextConst ENU = 'Qua.', ESP = 'Can.';
        //       Ud_CaptionLbl@7001107 :
        Ud_CaptionLbl: TextConst ENU = 'Ut.', ESP = 'Ud.';
        //       TRealizados_CaptionLbl@7001108 :
        TRealizados_CaptionLbl: TextConst ENU = 'Realized jobs', ESP = 'Trabajos realizados';
        //       Precio_CaptionLbl@7001109 :
        Precio_CaptionLbl: TextConst ENU = 'Price', ESP = 'Precio';
        //       Importe_CaptionLbl@7001110 :
        Importe_CaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       Conforme_CaptionLbl@7001111 :
        Conforme_CaptionLbl: TextConst ENU = 'Approved', ESP = 'Conforme';
        //       IVA_CaptionLbl@7001112 :
        IVA_CaptionLbl: TextConst ENU = 'IVA', ESP = 'IVA';
        //       TotalEjecucion_CaptionLbl@7001113 :
        TotalEjecucion_CaptionLbl: TextConst ENU = 'TOTAL MATERIAL EXECUTION', ESP = 'TOTAL EJECUCIàN MATERIAL';
        //       TotalPres_CaptionLbl@7001114 :
        TotalPres_CaptionLbl: TextConst ENU = 'TOTAL CONTRACTED BUDGET', ESP = 'TOTAL PRES. CONTRATA';
        //       OP_CaptionLbl@7001116 :
        OP_CaptionLbl: TextConst ENU = 'O.P.:', ESP = 'O.P.:';
        //       PurchRcptLine@7001115 :
        PurchRcptLine: Record 121;
        //       SumaLineas@7001117 :
        SumaLineas: Decimal;
        //       importeIVA@7001118 :
        importeIVA: Decimal;
        //       ImporteTotal@7001119 :
        ImporteTotal: Decimal;
        //       OutputNo@7001120 :
        OutputNo: Integer;
        //       NoOfCopies@7001122 :
        NoOfCopies: Integer;
        //       NoOfLoops@7001121 :
        NoOfLoops: Integer;
        //       CopyText@7001125 :
        CopyText: Text[30];
        //       DimText@7001124 :
        DimText: Text[120];
        //       OldDimText@7001123 :
        OldDimText: Text[75];
        //       FormatDocument@7001126 :
        FormatDocument: Codeunit 368;
        //       ShowInternalInfo@7001127 :
        ShowInternalInfo: Boolean;
        //       DimSetEntry1@7001129 :
        DimSetEntry1: Record 480;
        //       DimSetEntry2@7001128 :
        DimSetEntry2: Record 480;
        //       Continue@7001130 :
        Continue: Boolean;

    /*begin
    end.
  */

}




// report 50044 "Vesta: Albaran Venta"
// {



//   dataset
// {

// DataItem("Sales Shipment Header";"Sales Shipment Header")
// {

//                DataItemTableView=SORTING("No.");
//                RequestFilterFields="No.";
// Column(AlbaranNo_Caption;AlbaranNo_CaptionLbl)
// {
// //SourceExpr=Albar nNo_CaptionLbl;
// }Column(FechaPedido_Caption;FechaPedido_CaptionLbl)
// {
// //SourceExpr=FechaPedido_CaptionLbl;
// }Column(Proveedor_Caption;Proveedor_CaptionLbl)
// {
// //SourceExpr=Proveedor_CaptionLbl;
// }Column(FechaEntrega_Caption;FechaEntrega_CaptionLbl)
// {
// //SourceExpr=FechaEntrega_CaptionLbl;
// }Column(Direccion_Caption;Direccion_CaptionLbl)
// {
// //SourceExpr=Direccion_CaptionLbl;
// }Column(Poblacion_Caption;Poblacion_CaptionLbl)
// {
// //SourceExpr=Poblacion_CaptionLbl;
// }Column(OP_Caption;OP_CaptionLbl)
// {
// //SourceExpr=OP_CaptionLbl;
// }Column(Picture_CompanyInformation;CompanyInformation.Picture)
// {
// //SourceExpr=CompanyInformation.Picture;
// }Column(No_PurchRcptHeader;"Sales Shipment Header"."No.")
// {
// //SourceExpr="Sales Shipment Header"."No.";
// }Column(OrderDate_PurchRcptHeader;"Sales Shipment Header"."Order Date")
// {
// //SourceExpr="Sales Shipment Header"."Order Date";
// }Column(PostingDate_PurchRcptHeader;"Sales Shipment Header"."Posting Date")
// {
// //SourceExpr="Sales Shipment Header"."Posting Date";
// }Column(VendorName_PurchRcptHeader;"Sales Shipment Header"."Bill-to Name")
// {
// //SourceExpr="Sales Shipment Header"."Bill-to Name";
// }Column(VendorName2_PurchRcptHeader;"Sales Shipment Header"."Bill-to Name 2")
// {
// //SourceExpr="Sales Shipment Header"."Bill-to Name 2";
// }Column(City_PurchRcptHeader;"Sales Shipment Header"."Bill-to City")
// {
// //SourceExpr="Sales Shipment Header"."Bill-to City";
// }Column(PostCode_PurchRcptHeader;"Sales Shipment Header"."Bill-to Post Code")
// {
// //SourceExpr="Sales Shipment Header"."Bill-to Post Code";
// }Column(Address_PurchRcptHeader;"Sales Shipment Header"."Bill-to Address")
// {
// //SourceExpr="Sales Shipment Header"."Bill-to Address";
// }Column(Address2_PurchRcptHeader;"Sales Shipment Header"."Bill-to Address 2")
// {
// //SourceExpr="Sales Shipment Header"."Bill-to Address 2";
// }Column(VendorOrderNo_PurchRcptHeader;"Sales Shipment Header"."Job No.")
// {
// //SourceExpr="Sales Shipment Header"."Job No.";
// }Column(NroPedido;"Sales Shipment Header"."External Document No.")
// {
// //SourceExpr="Sales Shipment Header"."External Document No.";
// }Column(OutputNo;"Sales Shipment Header"."Job No.")
// {
// //SourceExpr="Sales Shipment Header"."Job No.";
// }DataItem("CopyLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// DataItem("PageLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
// Column(SumaLineas;SumaLineas)
// {
// //SourceExpr=SumaLineas;
// }Column(ImporteIVA;importeIVA)
// {
// //SourceExpr=importeIVA;
// }Column(VAT_PurchRcptLine;"Sales Shipment Line"."VAT %")
// {
// //SourceExpr="Sales Shipment Line"."VAT %";
// }Column(DirectunitCost_PurchRcptLine;"Sales Shipment Line"."Unit Cost (LCY)")
// {
// //SourceExpr="Sales Shipment Line"."Unit Cost (LCY)";
// }Column(UnitPrice_SalesShipmentLine;"Sales Shipment Line"."Unit Price")
// {
// //SourceExpr="Sales Shipment Line"."Unit Price";
// }Column(ImporteTotal;ImporteTotal)
// {
// //SourceExpr=ImporteTotal;
// }DataItem("Sales Shipment Line";"Sales Shipment Line")
// {

//                DataItemTableView=SORTING("Document No.","Line No.");
//                DataItemLinkReference="Sales Shipment Header";
// DataItemLink="Document No."= FIELD("No.");
// Column(Quantity_PurchRcptLine;"Sales Shipment Line".Quantity)
// {
// //SourceExpr="Sales Shipment Line".Quantity;
// }Column(Description_PurchRcptLine;"Sales Shipment Line".Description)
// {
// //SourceExpr="Sales Shipment Line".Description;
// }Column(Description2_PurchRcptLine;"Sales Shipment Line"."Description 2")
// {
// //SourceExpr="Sales Shipment Line"."Description 2";
// }Column(UnitofMeasure_PurchRcptLine;"Sales Shipment Line"."Unit of Measure")
// {
// //SourceExpr="Sales Shipment Line"."Unit of Measure";
// }Column(UnitofMeasureCode_PurchRcptLine;"Sales Shipment Line"."Unit of Measure Code")
// {
// //SourceExpr="Sales Shipment Line"."Unit of Measure Code";
// }Column(Can_Caption;Can_CaptionLbl)
// {
// //SourceExpr=Can_CaptionLbl;
// }Column(Ud_Caption;Ud_CaptionLbl)
// {
// //SourceExpr=Ud_CaptionLbl;
// }Column(TRealizados_Caption;TRealizados_CaptionLbl)
// {
// //SourceExpr=TRealizados_CaptionLbl;
// }Column(Precio_Caption;Precio_CaptionLbl)
// {
// //SourceExpr=Precio_CaptionLbl;
// }Column(Importe_Caption;Importe_CaptionLbl)
// {
// //SourceExpr=Importe_CaptionLbl;
// }Column(IVA_Caption;IVA_CaptionLbl)
// {
// //SourceExpr=IVA_CaptionLbl;
// }Column(TotalEjecution_Caption;TotalEjecucion_CaptionLbl)
// {
// //SourceExpr=TotalEjecucion_CaptionLbl;
// }Column(TotalPres_Caption;TotalPres_CaptionLbl)
// {
// //SourceExpr=TotalPres_CaptionLbl;
// }Column(Conforme_Caption;Conforme_CaptionLbl )
// {
// //SourceExpr=Conforme_CaptionLbl ;
// }trigger OnPreDataItem();
//     BEGIN 
//                                OutputNo := 1;

//                                NoOfLoops := ABS(NoOfCopies) + 1;
//                                CopyText := '';
//                                SETRANGE(Number,1,NoOfLoops);
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number > 1 THEN BEGIN 
//                                     CopyText := FormatDocument.GetCOPYText;
//                                     OutputNo += 1;
//                                   END;
//                                   CurrReport.PAGENO := 1;

//                                   SumaLineas := 0;
//                                   PurchRcptLine.RESET;
//                                   PurchRcptLine.SETRANGE("Document No.","Sales Shipment Line"."Document No.");
//                                   IF PurchRcptLine.FINDSET THEN
//                                     REPEAT
//                                       SumaLineas += PurchRcptLine.Quantity * PurchRcptLine."Unit Price";
//                                     UNTIL PurchRcptLine.NEXT = 0;

//                                   importeIVA := (PurchRcptLine."VAT %" * SumaLineas)/100;
//                                   ImporteTotal := SumaLineas + importeIVA;
//                                 END;


// }
// }
// }
// }
// }
//   requestpage
//   {

//     layout
// {
// }
//   }
//   labels
// {
// SPlbl='Su Pedido/';
// }

//     var
// //       Albar nNo_CaptionLbl@7001100 :
//       AlbaranNo_CaptionLbl: TextConst ENU='Shipment No:',ESP='DOCUMENTO:';
// //       FechaPedido_CaptionLbl@7001101 :
//       FechaPedido_CaptionLbl: TextConst ENU='ORDER DATE',ESP='FECHA';
// //       FechaEntrega_CaptionLbl@7001102 :
//       FechaEntrega_CaptionLbl: TextConst ENU='DELIVERY DATE',ESP='FECHA DE ENTREGA';
// //       Proveedor_CaptionLbl@7001103 :
//       Proveedor_CaptionLbl: TextConst ENU='Vendor:',ESP='Cliente:';
// //       Direccion_CaptionLbl@7001104 :
//       Direccion_CaptionLbl: TextConst ENU='Address:',ESP='Direcci¢n:';
// //       Poblacion_CaptionLbl@7001105 :
//       Poblacion_CaptionLbl: TextConst ENU='City:',ESP='Poblaci¢n:';
// //       Can_CaptionLbl@7001106 :
//       Can_CaptionLbl: TextConst ENU='Qua.',ESP='Can.';
// //       Ud_CaptionLbl@7001107 :
//       Ud_CaptionLbl: TextConst ENU='Ut.',ESP='Ud.';
// //       TRealizados_CaptionLbl@7001108 :
//       TRealizados_CaptionLbl: TextConst ENU='Realized jobs',ESP='Trabajos realizados';
// //       Precio_CaptionLbl@7001109 :
//       Precio_CaptionLbl: TextConst ENU='Price',ESP='Precio';
// //       Importe_CaptionLbl@7001110 :
//       Importe_CaptionLbl: TextConst ENU='Amount',ESP='Importe';
// //       Conforme_CaptionLbl@7001111 :
//       Conforme_CaptionLbl: TextConst ENU='Approved',ESP='Conforme';
// //       IVA_CaptionLbl@7001112 :
//       IVA_CaptionLbl: TextConst ENU='IVA',ESP='IVA';
// //       TotalEjecucion_CaptionLbl@7001113 :
//       TotalEjecucion_CaptionLbl: TextConst ENU='TOTAL MATERIAL EXECUTION',ESP='TOTAL EJECUCIàN MATERIAL';
// //       TotalPres_CaptionLbl@7001114 :
//       TotalPres_CaptionLbl: TextConst ENU='TOTAL CONTRACTED BUDGET',ESP='TOTAL DOCUMENTO';
// //       OP_CaptionLbl@7001116 :
//       OP_CaptionLbl: TextConst ENU='O.P.:',ESP='Proyecto:';
// //       PurchRcptLine@7001115 :
//       PurchRcptLine: Record 111;
// //       SumaLineas@7001117 :
//       SumaLineas: Decimal;
// //       importeIVA@7001118 :
//       importeIVA: Decimal;
// //       ImporteTotal@7001119 :
//       ImporteTotal: Decimal;
// //       OutputNo@7001120 :
//       OutputNo: Integer;
// //       NoOfCopies@7001122 :
//       NoOfCopies: Integer;
// //       NoOfLoops@7001121 :
//       NoOfLoops: Integer;
// //       CopyText@7001125 :
//       CopyText: Text[30];
// //       DimText@7001124 :
//       DimText: Text[120];
// //       OldDimText@7001123 :
//       OldDimText: Text[75];
// //       FormatDocument@7001126 :
//       FormatDocument: Codeunit 368;
// //       ShowInternalInfo@7001127 :
//       ShowInternalInfo: Boolean;
// //       DimSetEntry1@7001129 :
//       DimSetEntry1: Record 480;
// //       DimSetEntry2@7001128 :
//       DimSetEntry2: Record 480;
// //       Continue@7001130 :
//       Continue: Boolean;
// //       CompanyInformation@1000000000 :
//       CompanyInformation: Record 79;



// trigger OnInitReport();    begin
//                    CompanyInformation.GET;
//                    CompanyInformation.CALCFIELDS(Picture);
//                  end;



// /*begin
//     {
//       QVE7807 PGM 18/09/2019 - A¤adido el logotipo y el pie de p gina est ndar de Vesta
//     }
//     end.
//   */

// }





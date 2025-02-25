// report 50036 "Vesta: Proforma Invoice"
// {


//     CaptionML=ENU='Proforma Invoice',ESP='Vesta: Factura proforma';

//   dataset
// {

// DataItem("Purch. Rcpt. Header";"Purch. Rcpt. Header")
// {

//                DataItemTableView=SORTING("No.");
//                RequestFilterHeadingML=ENU='Posted Purchase Receipt',ESP='Hist¢rico albaranes compra';


//                RequestFilterFields="No.";
// Column(CAB_PurchRcptHeaderNo;"No.")
// {
// //SourceExpr="No.";
// }Column(CAB_JobNo;"Job No.")
// {
// //SourceExpr="Job No.";
// }Column(CAB_JobDescription;Job.Description + ' ' + Job."Description 2")
// {
// //SourceExpr=Job.Description + ' ' + Job."Description 2";
// }Column(CAB_PostingDate;"Posting Date")
// {
// //SourceExpr="Posting Date";
// }Column(CAB_BuyfromVendoNo;"Buy-from Vendor No.")
// {
// //SourceExpr="Buy-from Vendor No.";
// }Column(CAB_BuyfromVendoName;"Purch. Rcpt. Header"."Buy-from Vendor Name" + ' ' + "Purch. Rcpt. Header"."Buy-from Vendor Name 2")
// {
// //SourceExpr="Purch. Rcpt. Header"."Buy-from Vendor Name" + ' ' + "Purch. Rcpt. Header"."Buy-from Vendor Name 2";
// }Column(PaymentTermsDesc;PaymentTerms.Description)
// {
// //SourceExpr=PaymentTerms.Description;
// }Column(PaymentMethodDesc;PaymentMethod.Description)
// {
// //SourceExpr=PaymentMethod.Description;
// }Column(PercentageWithholding;WithholdingGroup."Percentage Withholding")
// {
// //SourceExpr=WithholdingGroup."Percentage Withholding";
// }Column(LineCount;LineCount)
// {
// //SourceExpr=LineCount;
// }Column(NUM_LINES_REPORT;NUM_LINES_REPORT)
// {
// //SourceExpr=NUM_LINES_REPORT;
// }Column(NUM_LINES_FOOT;NUM_LINES_FOOT)
// {
// //SourceExpr=NUM_LINES_FOOT;
// }Column(PaddingLine;PaddingLine)
// {
// //SourceExpr=PaddingLine;
// }DataItem("CopyLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// DataItem("PageLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
//                ;
// Column(CopyText;CopyText)
// {
// //SourceExpr=CopyText;
// }Column(PageLoop_Number;Number)
// {
// //SourceExpr=Number;
// }Column(NoOfCopies;NoOfCopies)
// {
// //SourceExpr=NoOfCopies;
// }Column(OutputNo;OutputNo)
// {
// //SourceExpr=OutputNo;
// }Column(IndexDoc;DocIndex)
// {
// //SourceExpr=DocIndex;
// }Column(AmountUO;AmountUO)
// {
// //SourceExpr=AmountUO;
//                AutoFormatType=1;
// }Column(VATAmount;VATAmount)
// {
// //SourceExpr=VATAmount;
//                AutoFormatType=1;
// }Column(AmountUOOld;AmountUOOld)
// {
// //SourceExpr=AmountUOOld;
//                AutoFormatType=1;
// }Column(ByVATApplied;ByVATApplied)
// {
// //SourceExpr=ByVATApplied;
// }Column(WithholdingAmount;WithholdingAmount)
// {
// //SourceExpr=WithholdingAmount;
//                AutoFormatType=1;
// }DataItem("Purch. Rcpt. Line";"Purch. Rcpt. Line")
// {

//                DataItemTableView=SORTING("Document No.","Line No.")
//                                  ORDER(Ascending)
//                                  WHERE("Quantity"=FILTER(<>0));


//                DataItemLinkReference="Purch. Rcpt. Header";
// DataItemLink="Document No."= FIELD("No.");
// Column(LIN_Orden;"Piecework N§" + FORMAT("Line No."))
// {
// //SourceExpr="Piecework N§" + FORMAT("Line No.");
// }Column(LIN_Color;Color)
// {
// //SourceExpr=Color;
// }Column(LIN_LineNo;"Line No.")
// {
// //SourceExpr="Line No.";
// }Column(LIN_PieceWorkNo;"Piecework N§")
// {
// //SourceExpr="Piecework N§";
// }Column(LIN_No;"No.")
// {
// //SourceExpr="No.";
// }Column(LIN_uoDesc;Description + ' ' + "Description 2")
// {
// //SourceExpr=Description + ' ' + "Description 2";
// }Column(LIN_CertifiedQuantity;Quantity)
// {
// DecimalPlaces=2:5;
//                //SourceExpr=Quantity;
// }Column(LIN_UnitOfMeasure;"Unit of Measure Code")
// {
// //SourceExpr="Unit of Measure Code";
// }Column(LIN_uoPrice;"Unit Cost (LCY)")
// {
// DecimalPlaces=0:6;
//                //SourceExpr="Unit Cost (LCY)";
//                AutoFormatType=2;
// }Column(LIN_uoAmount;AmountUO)
// {
// //SourceExpr=AmountUO;
//                AutoFormatType=1;
// }Column(Percentage;Percentage)
// {
// //SourceExpr=Percentage;
// }Column(uoUniqueCode;UniqueCode)
// {
// //SourceExpr=UniqueCode;
// }DataItem("QB Text";"QB Text")
// {

//                DataItemTableView=SORTING("Table","Key1","Key2")
//                                  WHERE("Table"=CONST("Job"));
// DataItemLink="Key1"= FIELD("Job No."),
//                             "Key2"= FIELD("Piecework N§");
// Column(ExtendedTextLineText;ExtendedLine)
// {
// //SourceExpr=ExtendedLine;
// }DataItem("otherLines";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(otherLines_Number;Number)
// {
// //SourceExpr=Number;
// }DataItem("Totals";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(AmountUOTot;AmountUOTot)
// {
// //SourceExpr=AmountUOTot;
// }Column(AmountUoOldTot;AmountUoOldTot)
// {
// //SourceExpr=AmountUoOldTot;
// }Column(AmountVATot;AmountVATot)
// {
// //SourceExpr=AmountVATot;
// }Column(AmountRetTot;AmountRetTot)
// {
// //SourceExpr=AmountRetTot;
// }Column(Totals_Number;Number )
// {
// //SourceExpr=Number ;
// }trigger OnPreDataItem();
//     BEGIN 
//                                SETRANGE(Number,1,1);
//                              END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                nlinesUltPag := LineCount MOD NUM_LINES_REPORT;

//                                IF ((nlinesUltPag + NUM_LINES_FOOT) <= NUM_LINES_REPORT) THEN BEGIN 
//                                  otherLines.SETRANGE(Number,nlinesUltPag + NUM_LINES_FOOT + 1,NUM_LINES_REPORT);
//                                  PaddingLine := NUM_LINES_REPORT;
//                                END
//                                ELSE BEGIN 
//                                   otherLines.SETRANGE(Number,nlinesUltPag + NUM_LINES_FOOT + 1,NUM_LINES_REPORT * 2);
//                                   PaddingLine := NUM_LINES_REPORT * 2;
//                                END
//                              END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                IF (NOT IncludeText) THEN
//                                  CurrReport.BREAK;
//                                IF (NOT DataPieceworkForProduction.GET("Purch. Rcpt. Line"."Job No.", "Purch. Rcpt. Line"."Piecework N§")) THEN
//                                  CurrReport.BREAK;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   LineCount += 1;
//                                   ExtendedLine := "QB Text".GetCostText;
//                                 END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                Color := TRUE;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF (NOT IncludeText) THEN
//                                     Color := (NOT Color)
//                                   ELSE
//                                     Color := TRUE;

//                                   AmountUO := ROUND("Unit Cost (LCY)" * Quantity,Currency."Amount Rounding Precision");
//                                   VATAmount := ROUND(AmountUO * "VAT %" / 100,Currency."Amount Rounding Precision");
//                                   IF "VAT %" <> 0 THEN
//                                     ByVATApplied := "VAT %";

//                                   IF WithholdingGroup."Withholding Base" = WithholdingGroup."Withholding Base"::"Invoice Amount" THEN
//                                     WithholdingAmount := ROUND(AmountUO * WithholdingGroup."Percentage Withholding" / 100,
//                                                                Currency."Amount Rounding Precision")
//                                   ELSE
//                                     WithholdingAmount := ROUND((AmountUO + VATAmount) * WithholdingGroup."Percentage Withholding" / 100,
//                                                                Currency."Amount Rounding Precision");

//                                   AmountUOTot := AmountUOTot + AmountUO;
//                                   AmountUoOldTot := AmountUoOldTot + AmountUOOld;
//                                   AmountVATot := AmountVATot + VATAmount;
//                                   AmountRetTot := AmountRetTot + WithholdingAmount;
//                                   LineCount += 1;
//                                 END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                LineCount := 0;
//                              END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                NoOfLoops := ABS(NoOfCopies) + 1;
//                                CopyText := '';
//                                SETRANGE(Number,1,NoOfLoops);

//                                OutputNo := 1;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number > 1 THEN BEGIN 
//                                     CopyText := textCOPY;
//                                     OutputNo += 1;
//                                   END;

//                                   CurrReport.PAGENO := 1;
//                                   DocIndex += 1;

//                                   AmountUOTot := 0;
//                                   AmountUoOldTot := 0;
//                                   AmountVATot := 0;
//                                   AmountRetTot := 0;
//                                 END;

// trigger OnPostDataItem();
//     BEGIN 
//                                 IF NOT CurrReport.PREVIEW THEN
//                                   PurchRcptPrinted.RUN("Purch. Rcpt. Header");
//                               END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                NUM_LINES_REPORT := 31;
//                                NUM_LINES_FOOT := 15;
//                                LineCount := 1;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                                   IF "Purchaser Code" = '' THEN BEGIN 
//                                     SalespersonPurchaser.INIT;
//                                   END ELSE BEGIN 
//                                     SalespersonPurchaser.GET("Purchaser Code");
//                                   END;
//                                   IF "Your Reference" = '' THEN
//                                     ReferenceText := ''
//                                   ELSE
//                                     ReferenceText := FIELDCAPTION("Your Reference");

//                                   FormatAddress.PurchRcptShipTo(ShipToAddr,"Purch. Rcpt. Header");
//                                   FormatAddress.PurchRcptPayTo(VendAddr,"Purch. Rcpt. Header");

//                                   IF NOT Job.GET("Purch. Rcpt. Header"."Job No.") THEN
//                                     CLEAR(Job);

//                                   IF NOT PaymentTerms.GET("Purch. Rcpt. Header"."Payment Terms Code") THEN
//                                     CLEAR(PaymentTerms);

//                                   IF NOT PaymentMethod.GET("Purch. Rcpt. Header"."Payment Method Code") THEN
//                                     CLEAR(PaymentMethod);

//                                   //Buscar el grupo de retenci¢n del pedido/contrato original
//                                   CLEAR(WithholdingGroup);
//                                   IF (PurchaseHeaderOrder.GET(PurchaseHeaderOrder."Document Type"::Order, "Purch. Rcpt. Header"."Order No.")) THEN BEGIN 
//                                     IF (PurchaseHeaderOrder."QW Cod. Withholding by GE" <> '') THEN
//                                       WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E",PurchaseHeaderOrder."QW Cod. Withholding by GE");
//                                   END;
//                                 END;


// }
// }
//   requestpage
//   {

//     layout
// {
// area(content)
// {
// group("group99")
// {

//                   CaptionML=ENU='Options',ESP='Opciones';
//     field("NoOfCopies";"NoOfCopies")
//     {

//                   CaptionML=ENU='No. Copies',ESP='N£m. Copias';
//     }
//     field("IncludeText";"IncludeText")
//     {

//                   CaptionML=ESP='Incluir Textos';
//     }

// }

// }
// }
//   }
//   labels
// {
// Purchaser='Purchaser/ Comprador/';
// PurchReceipt='Purchases - Receipt/ Compras - Albar n/';
// Page='Page/ P g./';
// Document='DOCUMENT NO./ DOCUMENTO/';
// NumDoc='DOCUMENT NO./ N§:/';
// Date='DATE/ Fecha:/';
// Subcontractor='SOBCONTRACTOR/ SUBCONTRATISTA/';
// JobL='JOB:/ OBRA:/';
// AmountInvoice='AMOUNT OF THIS INVOICE/ BASE IMPONIBLE/';
// Obs='OBSERVATIONS/ OBSERVACIONES/';
// Deduct='PREVIOUS CERTIFICATIONS TO DEDUCT/ A DEDUCIR POR CERTIFICACIONES ANTERIORES/';
// Liquidity='LIQUIDITY TO PAY/ LIQUIDO A PAGAR/';
// TheSubcontractor='THE SUBCONTRACTOR/ EL SUBCONTRATISTA/';
// JobLeader='THE JOB LEADER/ EL JEFE DE OBRA/';
// GroupProd='GROUP / PRODUCTION LEADER/ J. GRUPO / PRODUCCIàN/';
// NoSettle='* WON''T BE SETTLE THE TOTAL OF THE JOBS UNTIL CONTRACT DOCUMENTATION HAS BEEN DELIVERY./ * NO SE LIQUIDARµ EL TOTAL DE LOS TRABAJOS HASTA LA ENTREGA DE LA DOCUMENTACIàN DEL CONTRATO./';
// ValProforma='* THE VALIDITY OF THIS PROFORMA INVOICE IS SUBJECT TO THE SIGNATURE BY GROUP AND/OR PRODUCTION LEADER/ * LA VALIDEZ DE ESTA PROFORMA ESTµ SUPEDITADA A LA FIRMA POR PARTE DEL J. GRUPO Y/O J. PRODUCCION./';
// LblPieceWorkNo='PIECEWORK/ UNIDAD DE OBRA/';
// lblResource='PIECEWORK/ RECURSO N§/';
// lblConcept='CONCEPT/ CONCEPTO/';
// lblMeasurement='MEASUREMENT/ MEDICIàN/';
// LblUM='YOU/ U.M./';
// lblCostUnit='COST PER UNIT/ PRECIO DE LA UNIDAD/';
// lblTotal='TOTAL/ TOTAL/';
// lblReportCaption='MEASUREMENT CERTIFICATE/ PROFORMA DE MEDICIàN/';
// PaymentMet='PAYMENT METHOD:/ FORMA DE PAGO:/';
// PaymentDoc='PAYMENT DOCUMENT:/ DOCUMENTO DE COBRO:/';
// WithholdingGE='WITHHOLDING G.E./ RETENCIàN B.E./';
// PercVAT='% V.A.T./ % I.V.A./';
// Perc='%/ %/';
// WithholdingInvoice='WITHHOLDING % / THIS INVOICE/ % RETENCION / PRESENTE FACTURA/';
// }

//     var
// //       SalespersonPurchaser@7001154 :
//       SalespersonPurchaser: Record 13;
// //       Language@7001151 :
//       Language: Record 8;
// //       Job@1100286007 :
//       Job: Record 167;
// //       Currency@1100286005 :
//       Currency: Record 4;
// //       PurchaseLine@1100286006 :
//       PurchaseLine: Record 39;
// //       PaymentMethod@1100286003 :
//       PaymentMethod: Record 289;
// //       PaymentTerms@1100286002 :
//       PaymentTerms: Record 3;
// //       WithholdingGroup@1100286001 :
//       WithholdingGroup: Record 7207330;
// //       DataPieceworkForProduction@1100286008 :
//       DataPieceworkForProduction: Record 7207386;
// //       PurchaseHeaderOrder@1100286004 :
//       PurchaseHeaderOrder: Record 38;
// //       PurchRcptPrinted@7001149 :
//       PurchRcptPrinted: Codeunit 318;
// //       FormatAddress@1100286000 :
//       FormatAddress: Codeunit 365;
// //       VendAddr@7001147 :
//       VendAddr: ARRAY [8] OF Text[50];
// //       ShipToAddr@7001146 :
//       ShipToAddr: ARRAY [8] OF Text[50];
// //       ReferenceText@7001143 :
//       ReferenceText: Text[30];
// //       MoreLines@7001142 :
//       MoreLines: Boolean;
// //       NoOfLoops@7001140 :
//       NoOfLoops: Integer;
// //       CopyText@7001139 :
//       CopyText: Text[30];
// //       Continue@7001134 :
//       Continue: Boolean;
// //       CertifiedQuantity@7001128 :
//       CertifiedQuantity: Decimal;
// //       CertifiedQuantityOld@7001127 :
//       CertifiedQuantityOld: Decimal;
// //       Percentage@7001125 :
//       Percentage: Decimal;
// //       Price@7001124 :
//       Price: Decimal;
// //       AmountUO@7001123 :
//       AmountUO: Decimal;
// //       AmountUOOld@7001122 :
//       AmountUOOld: Decimal;
// //       ExtendedLine@7001119 :
//       ExtendedLine: Text;
// //       LineCount@7001117 :
//       LineCount: Integer;
// //       VATAmount@7001114 :
//       VATAmount: Decimal;
// //       WithholdingAmount@7001113 :
//       WithholdingAmount: Decimal;
// //       ByVATApplied@7001111 :
//       ByVATApplied: Decimal;
// //       OutputNo@7001109 :
//       OutputNo: Integer;
// //       DocIndex@7001108 :
//       DocIndex: Integer;
// //       nlinesUltPag@7001107 :
//       nlinesUltPag: Integer;
// //       NUM_LINES_REPORT@7001106 :
//       NUM_LINES_REPORT: Integer;
// //       NUM_LINES_FOOT@7001105 :
//       NUM_LINES_FOOT: Integer;
// //       PaddingLine@7001104 :
//       PaddingLine: Integer;
// //       AmountUOTot@7001103 :
//       AmountUOTot: Decimal;
// //       AmountUoOldTot@7001102 :
//       AmountUoOldTot: Decimal;
// //       AmountVATot@7001101 :
//       AmountVATot: Decimal;
// //       AmountRetTot@7001100 :
//       AmountRetTot: Decimal;
// //       textCOPY@7001156 :
//       textCOPY: TextConst ENU='COPY',ESP='COPIA';
// //       UniqueCode@1000000000 :
//       UniqueCode: Code[10];
// //       Color@1100286009 :
//       Color: Boolean;
// //       "------------------------------ Opciones"@1100286010 :
//       "------------------------------ Opciones": Integer;
// //       IncludeText@1100286011 :
//       IncludeText: Boolean;
// //       NoOfCopies@1100286012 :
//       NoOfCopies: Integer;



// trigger OnInitReport();    begin
//                    IncludeText := TRUE;
//                  end;



// /*begin
//     {
//       JDC 27/08/19: - QB9999 Created, based on 7207327
//       PGM 19/09/19: - QVE7807 A¤adidos el logotipo y el pie de p gina estandar de Vesta
//       JAV 08/10/19: - Se convierte en un report solo para Vesta
//     }
//     end.
//   */

// }





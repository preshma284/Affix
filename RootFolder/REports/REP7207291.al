report 7207291 "Invoiced Pending Shipments"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Invoiced Pending Shipments',ESP='Albaranes pendientes de facturar';
  
  dataset
{

DataItem("Purch. Rcpt. Header";"Purch. Rcpt. Header")
{

               DataItemTableView=SORTING("Buy-from Vendor No.","Posting Date","Job No.")
                                 ORDER(Ascending);
               

               RequestFilterFields="Buy-from Vendor No.","Posting Date","Job No.";
Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(FiltJob;FiltJob)
{
//SourceExpr=FiltJob;
}Column(FiltDate;FiltDate)
{
//SourceExpr=FiltDate;
}Column(JobNo;"Job No.")
{
//SourceExpr="Job No.";
}Column(JobDesc;Job.Description)
{
//SourceExpr=Job.Description;
}Column(JobDesc2;Job."Description 2")
{
//SourceExpr=Job."Description 2";
}Column(VendorNo;"Buy-from Vendor No.")
{
//SourceExpr="Buy-from Vendor No.";
}Column(VendorName;Vendor.Name)
{
//SourceExpr=Vendor.Name;
}Column(DocumentNo;"No.")
{
//SourceExpr="No.";
}Column(VendorShipmentNo;"Vendor Shipment No.")
{
//SourceExpr="Vendor Shipment No.";
}Column(PostingDate;"Posting Date")
{
//SourceExpr="Posting Date";
}Column(total;total)
{
//SourceExpr=total;
}Column(sumtotal;Sumtotal)
{
//SourceExpr=Sumtotal;
}Column(FiltBuyfromVendorNo;FiltBuyfromVendorNo )
{
//SourceExpr=FiltBuyfromVendorNo ;
}trigger OnPreDataItem();
    BEGIN 
                               //+Q18116
                               IF "Purch. Rcpt. Header".GETFILTER("No.") <> '' THEN
                                 FiltBuyfromVendorNo :=  "Purch. Rcpt. Header".GETFILTER("No.")
                               ELSE
                                 FiltBuyfromVendorNo := '---';
                               //-Q18116
                               IF "Purch. Rcpt. Header".GETFILTER("Job No.") <> '' THEN
                                 FiltJob :=  "Purch. Rcpt. Header".GETFILTER("Job No.")
                               ELSE
                                 FiltJob := Text01;

                               IF "Purch. Rcpt. Header".GETFILTER("Posting Date") <> '' THEN
                                 FiltDate :=  "Purch. Rcpt. Header".GETFILTER("Posting Date")
                               ELSE
                                 FiltDate := '---';

                               "Purch. Rcpt. Header".SETRANGE(Cancelled, FALSE);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF NOT Job.GET("Job No.") THEN
                                    Job.INIT;

                                  IF NOT Vendor.GET("Buy-from Vendor No.") THEN
                                    Vendor.INIT;

                                  Sumtotal := 0;
                                  PurchRcptLine.RESET;
                                  PurchRcptLine.SETRANGE("Document No.", "No.");
                                  IF (PurchRcptLine.FINDSET(FALSE)) THEN
                                    REPEAT
                                      total := ROUND((PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced") * PurchRcptLine."Unit Cost", 0.01);
                                      Sumtotal += total;
                                    UNTIL PurchRcptLine.NEXT = 0;

                                  IF Sumtotal = 0 THEN
                                    CurrReport.SKIP;
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
PageNo='Page No./ P g./';
TotalCaption='Total/ Total/';
FReg='Posting Date/ Fecha Registro/';
AmountOut='Amount Outstanding/ Importe Pendiente/';
QtyOut='Outstanding Quantity/ Cantidad Pendiente/';
Amount='Amount/ Importe/';
JobTotal='Job Total:/ Total proyecto:/';
Job='Job:/ Proyecto:/';
Vendor='Vendor/ Proveedor/';
AnalyticalConcept='Analytical Concept/ Conc. Anal¡./';
QtyInv='Quantity Invoice/ Cantidad Facturada/';
UnWork='Unitys Work/ Ud. Obra/';
UnMeasure='Units Measure/ Ud. Med./';
Cost='Cost Unitary/ Coste unitario/';
NameReport='Invoiced Pending Shipments/ Albaranes pendientes de facturar/';
Doc='Document N§/ N§ Doc./';
tnShiVen='Shipments Vendor N§/ N§ Albar n del Proveedor/';
Period='Period:/ Periodo:/';
}
  
    var
//       PurchRcptLine@1100286000 :
      PurchRcptLine: Record 121;
//       Job@7001103 :
      Job: Record 167;
//       Vendor@7001102 :
      Vendor: Record 23;
//       FiltJob@7001101 :
      FiltJob: Text[250];
//       FiltDate@7001100 :
      FiltDate: Text[250];
//       Text01@7001104 :
      Text01: TextConst ENU='All',ESP='Todos';
//       total@7001106 :
      total: Decimal;
//       Sumtotal@7001107 :
      Sumtotal: Decimal;
//       FiltBuyfromVendorNo@1100286001 :
      FiltBuyfromVendorNo: Text[250];

    /*begin
    end.
  */
  
}





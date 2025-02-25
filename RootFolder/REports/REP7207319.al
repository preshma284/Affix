report 7207319 "Weighted Average by Vendor"
{
  
  
    CaptionML=ENU='Weighted Average by Vendor',ESP='Media ponderada por proveedor';
  
  dataset
{

DataItem("Purchase Header";"Purchase Header")
{

               DataItemTableView=SORTING("Document Type","QB Job No.","Pay-to Vendor No.")
                                 WHERE("Document Type"=CONST("Order"),"QB Contract"=FILTER(true));
               ;
Column(BuyfromVendorNo_PurchaseHeader;"Purchase Header"."Buy-from Vendor No.")
{
//SourceExpr="Purchase Header"."Buy-from Vendor No.";
}Column(product;product)
{
//SourceExpr=product;
}Column(wAmount;wamount)
{
//SourceExpr=wamount;
}Column(wDays;wdays)
{
//SourceExpr=wdays;
}Column(JobNo_PurchaseHeader;"Purchase Header"."QB Job No.")
{
//SourceExpr="Purchase Header"."QB Job No.";
}Column(JobDesc;Job.Description)
{
//SourceExpr=Job.Description;
}Column(VendorName;Vendor.Name)
{
//SourceExpr=Vendor.Name;
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(PaytoVendorNo_PurchaseHeader;"Purchase Header"."Pay-to Vendor No.")
{
//SourceExpr="Purchase Header"."Pay-to Vendor No.";
}Column(PaytoName_PurchaseHeader;"Purchase Header"."Pay-to Name")
{
//SourceExpr="Purchase Header"."Pay-to Name";
}Column(average;average )
{
//SourceExpr=average ;
}trigger OnPreDataItem();
    BEGIN 
                               CurrReport.CREATETOTALS(product,days,wamount);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF NOT PaymentTerms.GET("Payment Terms Code") THEN
                                    CurrReport.SKIP;

                                  CALCFIELDS(Amount);

                                  dateAuxiliar1 := TODAY;
                                  dateauxiliar2 := CALCDATE(PaymentTerms."Due Date Calculation", dateAuxiliar1);
                                  days := dateauxiliar2 - dateAuxiliar1;

                                  product:=days*Amount;
                                  wamount:=Amount;
                                  wdays:=days;

                                  IF wamount <> 0 THEN
                                    average := product/wamount;

                                  IF ("QB Job No." <> '') THEN
                                    Job.GET("QB Job No.");

                                  IF ("Buy-from Vendor No." <> '') THEN
                                    Vendor.GET("Buy-from Vendor No.");
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
txtTotalJob='Job Total/ Total Proyecto/';
txtTotalVendor='VendorTotal/ TotalProveedor/';
txtNameReport='Weighted Average Jobs/Vendor/ Media Ponderada proyectos/proveedor/';
txtPageNo='Page No./ P g./';
txtJobName='Job Name/ Nombre proyecto/';
txtJob='Job No./ N§ Proy./';
txtPayToVendorNo='Vendor No./ N§ Prov./';
txtPayToName='Vendor Name/ Nombre proveedor/';
txtSumAmount='Sum of Amounts/ Suma de importes/';
txtWeightedAverage='Weighted Average/ Media ponderada/';
txtVendorAverage='Vendor Average/ Media del proveedor/';
txtGeneralAverage='General Average/ Media general/';
txtSumAmountbyDay='Sum of Amounts by days/ Suma de importes x d¡as/';
}
  
    var
//       PaymentTerms@7001115 :
      PaymentTerms: Record 3;
//       Installment@7001116 :
      Installment: Record 7000018;
//       days@7001114 :
      days: Decimal;
//       wdays@7001113 :
      wdays: Decimal;
//       product@7001112 :
      product: Decimal;
//       average@7001111 :
      average: Decimal;
//       wamount@7001110 :
      wamount: Decimal;
//       i@7001109 :
      i: Integer;
//       Fisrt@7001108 :
      Fisrt: Boolean;
//       varVendor@7001117 :
      varVendor: Code[20];
//       varJob@7001107 :
      varJob: Code[20];
//       dateAuxiliar1@7001106 :
      dateAuxiliar1: Date;
//       dateauxiliar2@7001105 :
      dateauxiliar2: Date;
//       Job@7001104 :
      Job: Record 167;
//       Date_Last_Contact@7001103 :
      Date_Last_Contact: Date;
//       Date_LastContact@7001102 :
      Date_LastContact: Code[10];
//       ComparativeQuoteHeader@7001101 :
      ComparativeQuoteHeader: Record 7207412;
//       Vendor@7001100 :
      Vendor: Record 23;

    /*begin
    end.
  */
  
}




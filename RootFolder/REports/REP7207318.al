report 7207318 "Weighted Average by Job"
{
  
  
    CaptionML=ESP='Media ponderada por proyecto',ENG='Weighted Average by Job';
  
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
}Column(JobNoDesc;Job.Description)
{
//SourceExpr=Job.Description;
}Column(ProvName;Vendor.Name)
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
txtJobTotal='Job Total/ Total Proyecto/';
txtVendorTotal='Vendor Total/ TotalProveedor/';
txtReportName='Weighted Average Jobs/Vendor/ Media ponderada proyectos/proveedor/';
txtPageNo='Page No./ P g./';
txtJob='Job/ Proyecto/';
txtDesc='Description/ Descripci¢n/';
txtPayToVendorNo='Vendor No./ N§ proveedor/';
txtPayToName='Vendor Name/ Nombre proveedor/';
txtSumAmount='Sum of Amounts/ Suma de importes/';
txtWeightedAverage='Weighted Average/ Media ponderada/';
txtJobAverage='Job Average/ Media del proyecto/';
txtGeneralAverage='General Average/ Media general/';
}
  
    var
//       PaymentTerms@7001106 :
      PaymentTerms: Record 3;
//       days@7001105 :
      days: Decimal;
//       wdays@7001101 :
      wdays: Decimal;
//       average@7001109 :
      average: Decimal;
//       product@7001100 :
      product: Decimal;
//       wamount@7001102 :
      wamount: Decimal;
//       dateAuxiliar1@7001108 :
      dateAuxiliar1: Date;
//       dateauxiliar2@7001107 :
      dateauxiliar2: Date;
//       Job@7001103 :
      Job: Record 167;
//       Vendor@7001104 :
      Vendor: Record 23;

    /*begin
    end.
  */
  
}




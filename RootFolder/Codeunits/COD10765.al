Codeunit 51306 "Sales Invoice Header - Edit 1"
{
  
  
    TableNo=112;
    Permissions=TableData 112=rm;
    trigger OnRun()
VAR
            SalesInvoiceHeader : Record 112;
          BEGIN
            SalesInvoiceHeader := Rec;
            SalesInvoiceHeader.LOCKTABLE;
            SalesInvoiceHeader.FIND;
            SalesInvoiceHeader."Special Scheme Code" := rec."Special Scheme Code";
            SalesInvoiceHeader."Invoice Type" := rec."Invoice Type";
            SalesInvoiceHeader."ID Type" := rec."ID Type";
            SalesInvoiceHeader."Succeeded Company Name" := rec."Succeeded Company Name";
            SalesInvoiceHeader."Succeeded VAT Registration No." := rec."Succeeded VAT Registration No.";
            SalesInvoiceHeader.TESTFIELD("No.",rec."No.");
            SalesInvoiceHeader.MODIFY;
            Rec := SalesInvoiceHeader;
          END;

    /* /*BEGIN
END.*/
}








Codeunit 51307 "Sales Cr.Memo Header - Edit 1"
{
  
  
    TableNo=114;
    Permissions=TableData 114=rm;
    trigger OnRun()
VAR
            SalesCrMemoHeader : Record 114;
          BEGIN
            SalesCrMemoHeader := Rec;
            SalesCrMemoHeader.LOCKTABLE;
            SalesCrMemoHeader.FIND;
            SalesCrMemoHeader."Special Scheme Code" := rec."Special Scheme Code";
            SalesCrMemoHeader."Cr. Memo Type" := rec."Cr. Memo Type";
            SalesCrMemoHeader."Correction Type" := rec."Correction Type";
            SalesCrMemoHeader.TESTFIELD("No.",rec."No.");
            SalesCrMemoHeader.MODIFY;
            Rec := SalesCrMemoHeader;
          END;

    /* /*BEGIN
END.*/
}








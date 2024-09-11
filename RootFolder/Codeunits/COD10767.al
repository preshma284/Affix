Codeunit 51308 "Purch. Cr. Memo Hdr. - Edit 1"
{


    TableNo = 124;
    Permissions = TableData 124 = rm;
    trigger OnRun()
    VAR
        PurchCrMemoHdr: Record 124;
    BEGIN
        PurchCrMemoHdr := Rec;
        PurchCrMemoHdr.LOCKTABLE;
        PurchCrMemoHdr.FIND;
        PurchCrMemoHdr."Special Scheme Code" := rec."Special Scheme Code";
        PurchCrMemoHdr."Cr. Memo Type" := rec."Cr. Memo Type";
        PurchCrMemoHdr."Correction Type" := rec."Correction Type";
        PurchCrMemoHdr.TESTFIELD("No.", rec."No.");
        PurchCrMemoHdr.MODIFY;
        Rec := PurchCrMemoHdr;
    END;

    /* /*BEGIN
END.*/
}








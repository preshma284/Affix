Codeunit 50036 "Document-Edit 1"
{


    TableNo = 7000002;
    Permissions = TableData 7000002 = imd,
                TableData 21 = m,
                TableData 25 = m,
                TableData 379 = m,
                TableData 380 = m;
    trigger OnRun()
    BEGIN
        CarteraDoc := Rec;
        CarteraDoc.LOCKTABLE;
        CarteraDoc.FIND;
        CarteraDoc."Category Code" := Rec."Category Code";
        CarteraDoc."Direct Debit Mandate ID" := Rec."Direct Debit Mandate ID";
        IF CarteraDoc."Bill Gr./Pmt. Order No." = '' THEN BEGIN
            CarteraDoc."Due Date" := Rec."Due Date";
            CarteraDoc."Cust./Vendor Bank Acc. Code" := Rec."Cust./Vendor Bank Acc. Code";
            CarteraDoc."Pmt. Address Code" := Rec."Pmt. Address Code";
            CarteraDoc."Collection Agent" := Rec."Collection Agent";
            CarteraDoc.Accepted := Rec.Accepted;
        END;
        OnBeforeModifyCarteraDoc(CarteraDoc);

        //QB El evento no sirve porque no pasa el valor en la page, solo el registro ya modificado.
        //Se puede cambiar vto y banco desde la orden de pago o remesa, y los 5 check de aprobaci�n siempre
        CarteraDoc."Due Date" := Rec."Due Date";
        CarteraDoc."Cust./Vendor Bank Acc. Code" := Rec."Cust./Vendor Bank Acc. Code";
        CarteraDoc."Approval Check 1" := Rec."Approval Check 1";
        CarteraDoc."Approval Check 2" := Rec."Approval Check 2";
        CarteraDoc."Approval Check 3" := Rec."Approval Check 3";
        CarteraDoc."Approval Check 4" := Rec."Approval Check 4";
        CarteraDoc."Approval Check 5" := Rec."Approval Check 5";

        //JAV 25/11/21: - QB 1.10.01 Se a�ade el banco
        CarteraDoc."QB Payment bank No." := Rec."QB Payment bank No."; //Q8960

        CarteraDoc.MODIFY;
        Rec := CarteraDoc;
    END;

    VAR
        CarteraDoc: Record 7000002;

    // PROCEDURE EditDueDate(CarteraDoc: Record 7000002);
    // VAR
    //     CustLedgEntry: Record 21;
    //     VendLedgEntry: Record 25;
    //     DtldCustLedgEntry: Record 379;
    //     DtldVendLedgEntry: Record 380;
    // BEGIN
    //     WITH CarteraDoc DO
    //         CASE Type OF
    //             Type::Receivable:
    //                 BEGIN
    //                     CustLedgEntry.GET("Entry No.");
    //                     CustLedgEntry."Due Date" := "Due Date";
    //                     CustLedgEntry.MODIFY;
    //                     DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Posting Date");
    //                     DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
    //                     DtldCustLedgEntry.MODIFYALL("Initial Entry Due Date", "Due Date");
    //                 END;
    //             Type::Payable:
    //                 BEGIN
    //                     VendLedgEntry.GET("Entry No.");
    //                     VendLedgEntry."Due Date" := "Due Date";
    //                     VendLedgEntry.MODIFY;
    //                     DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Posting Date");
    //                     DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
    //                     DtldVendLedgEntry.MODIFYALL("Initial Entry Due Date", "Due Date");
    //                 END;
    //         END;
    // END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeModifyCarteraDoc(VAR CarteraDoc: Record 7000002);
    BEGIN
    END;

    /* BEGIN
END.*/
}










Codeunit 7207294 "GetSubcontract"
{


    TableNo = 39;
    trigger OnRun()
    BEGIN
        PurchaseHeader.GET(rec."Document Type", rec."Document No.");
        DataPieceworkForProduction.SETCURRENTKEY(DataPieceworkForProduction."Job No.", DataPieceworkForProduction."No. Subcontracting Resource");
        DataPieceworkForProduction.SETRANGE("Job No.", PurchaseHeader."QB Job No.");

        Job.GET(PurchaseHeader."QB Job No.");
        DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Current Piecework Budget");

        DataPieceworkForProduction.SETFILTER("No. Subcontracting Resource", '<>%1', '');
        ProposeSubcontracting.SETTABLEVIEW(DataPieceworkForProduction);
        ProposeSubcontracting.LOOKUPMODE := TRUE;
        ProposeSubcontracting.PassPurchaseOrder(PurchaseHeader);
        ProposeSubcontracting.RUNMODAL;
    END;

    VAR
        PurchaseHeader: Record 38;
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        ProposeSubcontracting: Page 7207556;

    PROCEDURE CreateLines(VAR DataPieceworkForProdPass: Record 7207386);
    VAR
        PurchaseLine: Record 39;
        Job: Record 167;
        DataCostByPiecework: Record 7207387;
        locintUltMov: Integer;
    BEGIN
        WITH DataPieceworkForProdPass DO BEGIN
            IF DataPieceworkForProdPass.FINDFIRST THEN BEGIN
                Job.GET(DataPieceworkForProdPass."Job No.");
                PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                IF PurchaseLine.FINDLAST THEN
                    locintUltMov := PurchaseLine."Line No."
                ELSE
                    locintUltMov := 0;
                REPEAT
                    CLEAR(PurchaseLine);
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    locintUltMov := locintUltMov + 10000;
                    PurchaseLine."Line No." := locintUltMov;
                    PurchaseLine.INSERT(TRUE);
                    PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Resource);
                    PurchaseLine.VALIDATE("No.", DataPieceworkForProdPass."No. Subcontracting Resource");
                    PurchaseLine.VALIDATE("Unit of Measure Code", DataPieceworkForProdPass."Unit Of Measure");
                    PurchaseLine.MODIFY(TRUE);
                    PurchaseLine.VALIDATE("Piecework No.", DataPieceworkForProdPass."Piecework Code");
                    PurchaseLine.Description := DataPieceworkForProdPass.Description;
                    DataPieceworkForProdPass.CALCFIELDS("Budget Measure", "Total Measurement Production", "Aver. Cost Price Pend. Budget");
                    IF DataPieceworkForProdPass."Budget Measure" - DataPieceworkForProdPass."Total Measurement Production" > 0 THEN
                        PurchaseLine.VALIDATE(Quantity, DataPieceworkForProdPass."Budget Measure" - DataPieceworkForProdPass."Total Measurement Production");
                    //-Q18970.1
                    DataCostByPiecework.SETRANGE("Job No.", DataPieceworkForProdPass."Job No.");
                    DataCostByPiecework.SETRANGE("Piecework Code", DataPieceworkForProdPass."Piecework Code");
                    DataCostByPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                    DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Resource);
                    DataCostByPiecework.SETRANGE("No.", DataPieceworkForProdPass."No. Subcontracting Resource");
                    IF DataCostByPiecework.FINDSET THEN BEGIN
                        REPEAT
                            //IF DataCostByPiecework.GET(DataPieceworkForProdPass."Job No.",DataPieceworkForProdPass."Piecework Code",
                            //                       Job."Current Piecework Budget",
                            //                       DataCostByPiecework."Cost Type"::Resource,DataPieceworkForProdPass."No. Subcontracting Resource") THEN BEGIN
                            IF PurchaseHeader."Currency Code" = '' THEN
                                PurchaseLine.VALIDATE("Direct Unit Cost", DataCostByPiecework."Direct Unitary Cost (JC)")
                            ELSE
                                PurchaseLine.VALIDATE("Direct Unit Cost", DataCostByPiecework."Direct Unitary Cost (JC)" * PurchaseHeader."Currency Factor");
                            PurchaseLine.Description := DataCostByPiecework.Description;
                        UNTIL DataCostByPiecework.NEXT = 0;
                        //+Q18970.1
                    END;
                    PurchaseLine.MODIFY(TRUE);
                    InsertExtendedText(PurchaseLine, FALSE);
                UNTIL DataPieceworkForProdPass.NEXT = 0;
            END;
        END;
    END;

    PROCEDURE SetMedic(VAR PurchaseHeaderPass: Record 38);
    BEGIN
        PurchaseHeader.GET(PurchaseHeaderPass."Document Type", PurchaseHeaderPass."No.");
    END;

    PROCEDURE InsertExtendedText(parrecPurchaseLine: Record 39; Unconditionally: Boolean);
    VAR
        TransferExtendedText: Codeunit 378;
    BEGIN
        IF TransferExtendedText.PurchCheckIfAnyExtText(parrecPurchaseLine, Unconditionally) THEN BEGIN
            TransferExtendedText.InsertPurchExtText(parrecPurchaseLine);
        END;
    END;

    /*BEGIN
/*{
      AML 12/6/23  - Q18970.1 Adaptaciones nueva clave para Data cost by piecework.
    }
END.*/
}







